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
    func viewWillAppear()
    func addNewRecordTapped()
    func profileButtonTapped()
    func numberOfItems() -> Int
    func configure(_ cell: RemoteWorkCellable, for indexPath: IndexPath)
}

protocol RemoteWorkViewModelOutput: class {
    func setUp()
    func showTableView()
    func setActivityIndicator(isHidden: Bool)
    func updateView()
}

class RemoteWorkViewModel {
    private weak var userInterface: RemoteWorkViewModelOutput?
    private weak var coordinator: RemoteWorkCoordinatorType?
    
    private let apiClient: ApiClientRemoteWorkType
    private let itemsPerPage = 24
    private var response: RemoteWorkResponse?
    
    // MARK: - Initialization
    init(
        userInterface: RemoteWorkViewModelOutput,
        apiClient: ApiClientRemoteWorkType,
        coordinator: RemoteWorkCoordinatorType
    ) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.coordinator = coordinator
    }
}

// MARK: - RemoteWorkViewModelType
extension RemoteWorkViewModel: RemoteWorkViewModelType {
    func loadView() {
        self.userInterface?.setUp()
    }
    
    func viewWillAppear() {
        self.fetchRemoteWorks()
    }
    
    func addNewRecordTapped() {
        self.coordinator?.remoteWorkDidRequestForFormView()
    }
    
    func profileButtonTapped() {
        self.coordinator?.remoteWorkDidRequestForProfileView()
    }
    
    func numberOfItems() -> Int {
        return self.response?.records.count ?? 0
    }
    
    func configure(_ cell: RemoteWorkCellable, for indexPath: IndexPath) {
        guard let remoteWork = self.item(for: indexPath) else { return }
        let viewModel = RemoteWorkCellViewModel(userInterface: cell, remoteWork: remoteWork)
        cell.configure(viewModel: viewModel)
    }
}

// MARK: - Private
extension RemoteWorkViewModel {
    private func item(for index: IndexPath) -> RemoteWork? {
        return self.response?.records[safeIndex: index.row]
    }
    
    private func fetchRemoteWorks() {
        // TO_DO - TIM-293 pagination
        let parameters = RemoteWorkParameters(page: 0, perPage: self.itemsPerPage)
        self.userInterface?.setActivityIndicator(isHidden: false)
        _ = self.apiClient.fetchRemoteWork(parameters: parameters) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case let .success(response):
                self?.handleFetch(response: response)
            case let .failure(error):
                self?.handleFetch(error: error)
            }
        }
    }
    
    private func handleFetch(response: RemoteWorkResponse) {
        self.response = response
        self.userInterface?.showTableView()
        self.userInterface?.updateView()
    }
    
    private func handleFetch(error: Error) {
        // TO_DO - TIM-292 error handling
    }
}
