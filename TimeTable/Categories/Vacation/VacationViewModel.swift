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
    func setUpTableHeaderView()
    func setActivityIndicator(isHidden: Bool)
    func updateView()
}

protocol VacationViewModelType: class {
    func viewWillAppear()
    func viewRequestForProfileView()
    func numberOfItems() -> Int
    func item(at index: IndexPath) -> VacationResponse.Vacation?
    func configure(_ cell: VacationCell, for indexPath: IndexPath)
    func configure(_ view: VacationTableHeaderViewable)
    func configure(_ view: ErrorViewable)
}

class VacationViewModel: ObservableObject {
    private weak var userInterface: VacationViewModelOutput?
    private weak var coordinator: VacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let errorHandler: ErrorHandlerType
    private var errorViewModel: ErrorViewModelParentType?
    
    private var selectedYear: Int
    
    private var decisionState: DecisionState = .fetching {
        didSet {
            switch self.decisionState {
            case let .error(error):
                self.userInterface?.setActivityIndicator(isHidden: true)
                self.handleFetch(error: error)
            case let .fetched(response):
                self.userInterface?.setActivityIndicator(isHidden: true)
                self.handleFetch(vacation: response.vacation)
            case .fetching:
                self.userInterface?.setActivityIndicator(isHidden: false)
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
        
        self.selectedYear = Calendar.autoupdatingCurrent.component(.year, from: Date())
    }
}

// MARK: - Structures
extension VacationViewModel {
    enum DecisionState {
        case fetching
        case error(Error)
        case fetched(VacationResponse)
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
        case let .fetched(response): return response.vacation.count
        case .error, .fetching: return 0
        }
    }
    
    func item(at index: IndexPath) -> VacationResponse.Vacation? {
        switch self.decisionState {
        case let .fetched(response): return response.vacation[safeIndex: index.row]
        case .error, .fetching: return nil
        }
    }
    
    func configure(_ cell: VacationCell, for indexPath: IndexPath) {
        guard let vacation = item(at: indexPath) else { return }
        let viewModel = VacationCellViewModel(userInterface: cell, vacation: vacation)
        cell.configure(viewModel: viewModel)
    }
    
    func configure(_ view: VacationTableHeaderViewable) {
        var availableVacationDays = 0
        switch self.decisionState {
        case let .fetched(response): availableVacationDays = response.availableVacationDays
        case .error, .fetching: break
        }
        let viewModel = VacationTableHeaderViewModel(
            userInterface: view,
            availableVacationDays: availableVacationDays,
            selectedYear: self.selectedYear,
            onYearSelection: self.onYearSelection,
            onMoreInfoSelection: self.onMoreInfoSelection)
        view.configure(viewModel: viewModel)
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
    private func onYearSelection(_ year: Int) {
        self.selectedYear = year
        self.fetchVacation()
    }
    
    private func onMoreInfoSelection() {
        // TO_DO: - present more information about vacation types
    }
    
    private func fetchVacation() {
        self.decisionState = .fetching
        _ = self.apiClient.fetchVacation(parameters: VacationParameters(year: self.selectedYear)) { result in
            switch result {
            case let .success(response):
                self.decisionState = .fetched(response)
            case let .failure(error):
                self.decisionState = .error(error)
            }
        }
    }
    
    private func handleFetch(vacation: [VacationResponse.Vacation]) {
        self.userInterface?.showTableView()
        self.userInterface?.updateView()
        self.userInterface?.setUpTableHeaderView()
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
