//
//  VacationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol VacationViewModelOutput: class {
    func setUpView()
    func showTableView()
    func showErrorView()
    func setActivityIndicator(isHidden: Bool)
    func updateView()
}

protocol VacationViewModelType: class {
    func viewWillAppear()
    func viewRequestForProfileView()
    func numberOfItems() -> Int
    func item(at index: IndexPath) -> VacationResponse.Vacation?
    func configure(_ cell: VacationCell, for indexPath: IndexPath)
    func configure(_ view: ErrorViewable)
}

class VacationViewModel: ObservableObject {
    private weak var userInterface: VacationViewModelOutput?
    private weak var coordinator: VacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let errorHandler: ErrorHandlerType
    
    private var errorViewModel: ErrorViewModelParentType?
    
    private var decisionState: DecisionState = .fetching {
        didSet {
            switch self.decisionState {
            case let .error(error):
                self.handleFetch(error: error)
            case let .fetched(vacation):
                self.handleFetch(vacation: vacation)
            case .fetching: break
            }
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: VacationViewModelOutput,
        apiClient: ApiClientVacationType,
        errorHandler: ErrorHandlerType,
        coordinator: VacationCoordinatorDelegate
    ) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.coordinator = coordinator
    }
}

// MARK: - Structures
extension VacationViewModel {
    enum DecisionState {
        case fetching
        case error(Error)
        case fetched([VacationResponse.Vacation])
    }
}

// MARK: - VacationViewModelType
extension VacationViewModel: VacationViewModelType {
    func viewWillAppear() {
        self.userInterface?.setUpView()
        self.fetchVacation()
    }
    
    func viewRequestForProfileView() {
        self.coordinator?.vacationRequestedForProfileView()
    }
    
    func numberOfItems() -> Int {
        switch self.decisionState {
        case let .fetched(vacation): return vacation.count
        case .error, .fetching: return 0
        }
    }
    
    func item(at index: IndexPath) -> VacationResponse.Vacation? {
        switch self.decisionState {
        case let .fetched(vacation): return vacation[safeIndex: index.row]
        case .error, .fetching: return nil
        }
    }
    
    func configure(_ cell: VacationCell, for indexPath: IndexPath) {
        guard let vacation = item(at: indexPath) else { return }
        let viewModel = VacationCellViewModel(userInterface: cell, vacation: vacation)
        cell.configure(viewModel: viewModel)
    }
    
    func configure(_ view: ErrorViewable) {
        let viewModel = ErrorViewModel(userInterface: view, error: UIError.genericError) { [weak self] in
            self?.fetchVacation()
        }
        view.configure(viewModel: viewModel)
        self.errorViewModel = viewModel
    }
}

// MARK: - Private
extension VacationViewModel {
    private func fetchVacation() {
        _ = self.apiClient.fetchVacation(parameters: VacationParameters(year: 2020)) { result in
            switch result {
            case let .success(response):
                self.decisionState = .fetched(response.vacation)
            case let .failure(error):
                self.decisionState = .error(error)
            }
        }
    }
    
    private func handleFetch(vacation: [VacationResponse.Vacation]) {
        self.userInterface?.showTableView()
        self.userInterface?.updateView()
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            if error.type == .unauthorized {
                self.errorHandler.throwing(error: error)
            } else {
                self.errorViewModel?.update(error: error)
            }
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
}
