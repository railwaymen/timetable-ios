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
    func configure(_ cell: RemoteWorkCellable, for indexPath: IndexPath)
    func viewWillDisplayCell(at indexPath: IndexPath)
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void)
}

protocol RemoteWorkViewModelOutput: class {
    func setUp()
    func showTableView()
    func setActivityIndicator(isHidden: Bool)
    func updateView()
    func removeRows(at indexPaths: [IndexPath])
    func getMaxCellsPerTableHeight() -> Int
}

class RemoteWorkViewModel {
    private weak var userInterface: RemoteWorkViewModelOutput?
    private weak var coordinator: RemoteWorkCoordinatorType?
    private let apiClient: ApiClientRemoteWorkType
    private let errorHandler: ErrorHandlerType
    
    private let tableHeightsPerPage: Int = 4
    private var cellsPerTableHeight: Int = 6
    private var state: State?
    private var records: [RemoteWork] = []
    
    private var recordsPerPage: Int {
        self.cellsPerTableHeight * self.tableHeightsPerPage
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
    }
}

// MARK: - Structures
extension RemoteWorkViewModel {
    enum State: Equatable {
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
        self.setUpRecordsNumberPerPage()
        self.fetchFirstPage()
    }
    
    func addNewRecordTapped() {
        self.coordinator?.remoteWorkDidRequestForFormView()
    }
    
    func profileButtonTapped() {
        self.coordinator?.remoteWorkDidRequestForProfileView()
    }
    
    func numberOfItems() -> Int {
        return self.records.count
    }
    
    func configure(_ cell: RemoteWorkCellable, for indexPath: IndexPath) {
        guard let remoteWork = self.item(for: indexPath) else { return }
        let viewModel = RemoteWorkCellViewModel(userInterface: cell, remoteWork: remoteWork)
        cell.configure(viewModel: viewModel)
    }
    
    func viewWillDisplayCell(at indexPath: IndexPath) {
        let tableHeightsToEndToStartFetchingNextPage = 1
        let cellsToEndToStartFetchingNextPage = self.cellsPerTableHeight * tableHeightsToEndToStartFetchingNextPage
        let cellToBeginFetching = self.records.count - cellsToEndToStartFetchingNextPage
        guard cellToBeginFetching <= indexPath.row else { return }
        self.fetchNextPage()
    }
    
    func viewRequestToDelete(at index: IndexPath, completion: @escaping (Bool) -> Void) {
        guard let remoteWork = self.item(for: index) else { return completion(false) }
        self.userInterface?.setActivityIndicator(isHidden: false)
        _ = self.apiClient.deleteRemoteWork(remoteWork) { [weak self] result in
            guard let self = self else { return completion(false) }
            self.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success:
                self.remove(remoteWork: remoteWork, completion: completion)
            case let .failure(error):
                self.errorHandler.throwing(error: error)
                completion(false)
            }
        }
    }
}

// MARK: - Private
extension RemoteWorkViewModel {
    private func setUpRecordsNumberPerPage() {
        guard let cellsPerTableHeight = self.userInterface?.getMaxCellsPerTableHeight() else { return }
        guard cellsPerTableHeight != 0 else {
            self.errorHandler.stopInDebug()
            return
        }
        self.cellsPerTableHeight = cellsPerTableHeight
    }
    
    private func item(for index: IndexPath) -> RemoteWork? {
        self.records[safeIndex: index.row]
    }
    
    private func fetchFirstPage() {
        guard self.state == .none || self.state == .firstPageFetchFailed else { return }
        let pageNumber = 1
        let parameters = self.parameters(forPage: pageNumber)
        self.state = .fetching(page: pageNumber)
        self.userInterface?.setActivityIndicator(isHidden: false)
        _ = self.apiClient.fetchRemoteWork(parameters: parameters) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
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
    }
    
    private func handleFirstPageFetchFailure(error: Error) {
        self.state = .firstPageFetchFailed
        // TODO: TIM-292 error handling
    }
    
    private func fetchNextPage() {
        guard let previousState = self.state else { return }
        guard case let .fetched(lastFetchedPage, totalPages) = self.state else { return }
        guard lastFetchedPage < totalPages else { return }
        let nextPage = lastFetchedPage + 1
        let parameters = self.parameters(forPage: nextPage)
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
    }
    
    private func handleNextPageFetchFailure(error: Error, previousState: State) {
        self.state = previousState
        // TODO: TIM-292 error handling
    }
    
    private func parameters(forPage page: Int) -> RemoteWorkParameters {
        RemoteWorkParameters(page: page, perPage: self.recordsPerPage)
    }
    
    private func remove(remoteWork: RemoteWork, completion: @escaping (Bool) -> Void) {
        guard let index = self.records.firstIndex(of: remoteWork) else { return completion(false) }
        _ = self.records.remove(at: index)
        self.userInterface?.removeRows(at: [IndexPath(row: index, section: 0)])
        completion(true)
    }
}
