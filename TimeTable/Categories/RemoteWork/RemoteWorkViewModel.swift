//
//  RemoteWorkViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol RemoteWorkViewModelType: class {
    func loadView()
    func viewDidLayoutSubviews()
    func addNewRecordTapped()
    func profileButtonTapped()
    func numberOfItems() -> Int
    func configure(_ view: ErrorViewable)
    func configure(_ cell: RemoteWorkCellable, for indexPath: IndexPath)
    func viewWillDisplayCell(at indexPath: IndexPath)
    func viewDidSelectCell(at indexPath: IndexPath)
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void)
    func viewRequestToRefresh(completion: @escaping () -> Void)
}

protocol RemoteWorkViewModelOutput: class {
    func setUp()
    func showTableView()
    func showErrorView()
    func setActivityIndicator(isAnimating: Bool)
    func setBottomContentInset(isHidden: Bool)
    func updateView()
    func removeRows(at indexPaths: [IndexPath])
    func getMaxCellsPerTableHeight() -> Int
    func deselectAllRows()
}

class RemoteWorkViewModel {
    private weak var userInterface: RemoteWorkViewModelOutput?
    private weak var coordinator: RemoteWorkCoordinatorType?
    private let apiClient: ApiClientRemoteWorkType
    private let errorHandler: ErrorHandlerType
    private let smoothLoadingManager: SmoothLoadingManagerType
    
    private weak var errorViewModel: ErrorViewModelParentType?
    private var records: [RemoteWork] = []
    private var paginationManager: PaginationManagerType?
    
    private var state: State? {
        didSet {
            switch self.state {
            case .fetching:
                self.errorViewModel?.setRefreshButton(isEnabled: false)
            case .fetched:
                self.errorViewModel?.setRefreshButton(isEnabled: true)
            case .firstPageFetchFailed:
                self.errorViewModel?.setRefreshButton(isEnabled: true)
            case .none:
                self.errorViewModel?.setRefreshButton(isEnabled: true)
            }
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: RemoteWorkViewModelOutput,
        coordinator: RemoteWorkCoordinatorType,
        apiClient: ApiClientRemoteWorkType,
        errorHandler: ErrorHandlerType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.smoothLoadingManager = SmoothLoadingManager { [weak userInterface] isAnimating in
            userInterface?.setActivityIndicator(isAnimating: isAnimating)
        }
    }
}

// MARK: - Structures
extension RemoteWorkViewModel {
    private enum State: Equatable {
        case fetching(page: Int)
        case fetched(page: Int, totalPages: Int)
        case firstPageFetchFailed
    }
}

// MARK: - RemoteWorkViewModelType
extension RemoteWorkViewModel: RemoteWorkViewModelType {
    func loadView() {
        self.userInterface?.setUp()
    }
    
    func viewDidLayoutSubviews() {
        guard self.state == .none else { return }
        self.setUpPaginationManager()
        self.fetchFirstPage()
    }
    
    func addNewRecordTapped() {
        self.coordinator?.remoteWorkDidRequestForNewFormView { [weak self] newRecords in
            self?.handleNewRecords(newRecords)
        }
    }
    
    func profileButtonTapped() {
        self.coordinator?.remoteWorkDidRequestForProfileView()
    }
    
    func numberOfItems() -> Int {
        return self.records.count
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, localizedError: UIError.genericError) { [weak self] in
            self?.fetchFirstPage()
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
    
    func configure(_ cell: RemoteWorkCellable, for indexPath: IndexPath) {
        guard let remoteWork = self.item(for: indexPath) else { return }
        let viewModel = RemoteWorkCellViewModel(userInterface: cell, remoteWork: remoteWork)
        cell.configure(viewModel: viewModel)
    }
    
    func viewWillDisplayCell(at indexPath: IndexPath) {
        self.paginationManager.unwrapped(using: self.errorHandler)?.tableViewWillDisplayCell(
            index: indexPath.row,
            allCellsCount: self.records.count)
    }
    
    func viewDidSelectCell(at indexPath: IndexPath) {
        guard let item = self.item(for: indexPath) else {
            self.userInterface?.deselectAllRows()
            return
        }
        self.coordinator?.remoteWorkDidRequestForEditFormView(entry: item) { [weak self] updatedRecords in
            self?.userInterface?.deselectAllRows()
            self?.handleUpdateRecords(updatedRecords)
        }
    }
    
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void) {
        guard let remoteWork = self.item(for: index) else { return completion(false) }
        self.userInterface?.setActivityIndicator(isAnimating: true)
        _ = self.apiClient.deleteRemoteWork(remoteWork) { [weak self] result in
            guard let self = self else { return completion(false) }
            self.userInterface?.setActivityIndicator(isAnimating: false)
            switch result {
            case .success:
                self.remove(remoteWork: remoteWork, completion: completion)
            case let .failure(error):
                self.errorHandler.throwing(error: error)
                completion(false)
            }
        }
    }
    
    func viewRequestToRefresh(completion: @escaping () -> Void) {
        self.fetchFirstPage(showActivityIndicator: false, completion: completion)
    }
}

// MARK: - Private
extension RemoteWorkViewModel {
    private func setUpPaginationManager() {
        guard let cellsPerTableHeight = self.userInterface?.getMaxCellsPerTableHeight() else { return }
        guard cellsPerTableHeight != 0 else {
            self.errorHandler.stopInDebug()
            return
        }
        self.paginationManager = PaginationManager(cellsPerTableHeight: cellsPerTableHeight, fetchNextPageHandler: {
            [weak self] in
            self?.fetchNextPage()
        })
    }
    
    private func item(for index: IndexPath) -> RemoteWork? {
        self.records[safeIndex: index.row]
    }
    
    private func fetchFirstPage(showActivityIndicator: Bool = true, completion: (() -> Void)? = nil) {
        let pageNumber = 1
        guard let parameters = self.parameters(forPage: pageNumber) else { return }
        self.state = .fetching(page: pageNumber)
        if showActivityIndicator {
            self.smoothLoadingManager.showActivityIndicatorWithDelay()
        }
        _ = self.apiClient.fetchRemoteWork(parameters: parameters) { [weak self] result in
            defer { completion?() }
            if showActivityIndicator {
                self?.smoothLoadingManager.hideActivityIndicator()
            }
            switch result {
            case let .success(response):
                self?.handleFirstPageFetchSuccess(response: response)
            case let .failure(error):
                self?.handleFirstPageFetchFailure(error: error)
            }
        }
    }
    
    private func handleFirstPageFetchSuccess(response: RemoteWorkResponse) {
        self.records = response.records
        self.state = .fetched(page: 1, totalPages: response.totalPages)
        self.userInterface?.showTableView()
        self.userInterface?.updateView()
        self.updateBottomInset(pageFetched: 1, totalPages: response.totalPages)
    }
    
    private func handleFirstPageFetchFailure(error: Error) {
        self.state = .firstPageFetchFailed
        self.errorViewModel?.update(localizedError: error as? ApiClientError ?? UIError.genericError)
        self.userInterface?.showErrorView()
    }
    
    private func fetchNextPage() {
        guard let previousState = self.state else { return }
        guard case let .fetched(lastFetchedPage, totalPages) = self.state else { return }
        guard lastFetchedPage < totalPages else { return }
        let nextPage = lastFetchedPage + 1
        guard let parameters = self.parameters(forPage: nextPage) else { return }
        self.state = .fetching(page: nextPage)
        _ = self.apiClient.fetchRemoteWork(parameters: parameters) { [weak self] result in
            switch result {
            case let .success(response):
                self?.handleNextPageFetchSuccess(response: response, pageFetched: nextPage)
            case let .failure(error):
                self?.handleNextPageFetchFailure(error: error, previousState: previousState)
            }
        }
    }
    
    private func handleNextPageFetchSuccess(response: RemoteWorkResponse, pageFetched: Int) {
        self.records.append(contentsOf: response.records)
        self.state = .fetched(page: pageFetched, totalPages: response.totalPages)
        self.userInterface?.updateView()
        self.updateBottomInset(pageFetched: pageFetched, totalPages: response.totalPages)
    }
    
    private func handleNextPageFetchFailure(error: Error, previousState: State) {
        self.state = previousState
        guard !(error is ApiClientError) else { return }
        self.errorHandler.throwing(error: error)
    }
    
    private func parameters(forPage page: Int) -> RemoteWorkParameters? {
        guard let paginationManager = self.paginationManager.unwrapped(using: self.errorHandler) else { return nil }
        return RemoteWorkParameters(page: page, perPage: paginationManager.recordsPerPage)
    }
    
    private func remove(remoteWork: RemoteWork, completion: @escaping (Bool) -> Void) {
        guard let index = self.records.firstIndex(of: remoteWork) else { return completion(false) }
        _ = self.records.remove(at: index)
        self.userInterface?.removeRows(at: [IndexPath(row: index, section: 0)])
        completion(true)
    }
    
    private func handleNewRecords(_ newRecords: [RemoteWork]) {
        self.records += newRecords
        self.records.sort(by: { $0.startsAt > $1.startsAt })
        self.userInterface?.updateView()
    }
    
    private func handleUpdateRecords(_ updatedRecords: [RemoteWork]) {
        self.records = self.records.map { record in
            let newItem = updatedRecords.first(where: { $0.id == record.id })
            return newItem ?? record
        }
        self.userInterface?.updateView()
    }
    
    private func updateBottomInset(pageFetched: Int, totalPages: Int) {
        guard pageFetched == totalPages else { return }
        self.userInterface?.setBottomContentInset(isHidden: true)
    }
}
