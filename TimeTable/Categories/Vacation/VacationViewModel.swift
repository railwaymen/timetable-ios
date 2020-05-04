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
    func dismissKeyboard()
}

protocol VacationViewModelType: class {
    func loadView()
    func viewWillAppear()
    func viewRequestForVacationForm()
    func viewRequestForProfileView()
    func viewHasBeenTapped()
    func numberOfItems() -> Int
    func item(at index: IndexPath) -> VacationDecoder?
    func configure(_ cell: VacationCellable, for indexPath: IndexPath)
    func configure(_ view: VacationTableHeaderViewable)
    func configure(_ view: ErrorViewable)
}

class VacationViewModel: ObservableObject {
    private weak var userInterface: VacationViewModelOutput?
    private weak var coordinator: VacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let errorHandler: ErrorHandlerType
    private var errorViewModel: ErrorViewModelParentType?
    private weak var headerViewModel: VacationTableHeaderViewModelable?
    
    private var selectedYear: Int
    
    private var decisionState: DecisionState = .fetching {
        didSet {
            switch self.decisionState {
            case let .error(error):
                self.userInterface?.setActivityIndicator(isHidden: true)
                self.handleFetch(error: error)
            case let .fetched(response):
                self.userInterface?.setActivityIndicator(isHidden: true)
                self.handleFetch(response: response)
            case .fetching:
                self.userInterface?.setActivityIndicator(isHidden: false)
            }
        }
    }
    
    private var availableVacationDays: Int {
        switch self.decisionState {
        case let .fetched(response): return response.availableVacationDays
        case .error, .fetching: return 0
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
    func loadView() {
        self.userInterface?.setUpView()
    }
    
    func viewWillAppear() {
        self.fetchVacation()
    }
    
    func viewRequestForVacationForm() {
        self.coordinator?.vacationRequestedForNewVacationForm(
            availableVacationDays: self.availableVacationDays,
            finishHandler: { [weak self] response in
                guard response != nil else { return }
                self?.fetchVacation()
        })
    }
    
    func viewRequestForProfileView() {
        self.coordinator?.vacationRequestedForProfileView()
    }
    
    func viewHasBeenTapped() {
        self.userInterface?.dismissKeyboard()
    }
    
    func numberOfItems() -> Int {
        switch self.decisionState {
        case let .fetched(response): return response.records.count
        case .error, .fetching: return 0
        }
    }
    
    func item(at index: IndexPath) -> VacationDecoder? {
        switch self.decisionState {
        case let .fetched(response): return response.records[safeIndex: index.row]
        case .error, .fetching: return nil
        }
    }
    
    func configure(_ cell: VacationCellable, for indexPath: IndexPath) {
        guard let vacation = self.item(at: indexPath) else { return }
        let viewModel = VacationCellViewModel(userInterface: cell, vacation: vacation)
        cell.configure(viewModel: viewModel)
    }

    func configure(_ view: VacationTableHeaderViewable) {
        let viewModel = VacationTableHeaderViewModel(
            userInterface: view,
            availableVacationDays: self.availableVacationDays,
            selectedYear: self.selectedYear,
            onYearSelection: self.onYearSelection,
            onMoreInfoSelection: self.onMoreInfoSelection)
        view.configure(viewModel: viewModel)
        self.headerViewModel = viewModel
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
        switch self.decisionState {
        case let .fetched(response):
            self.coordinator?.vacationRequestedForUsedDaysView(usedDays: response.usedVacationDays)
        case .error, .fetching: break
        }
    }
    
    private func fetchVacation() {
        self.decisionState = .fetching
        let paramters = VacationParameters(year: self.selectedYear)
        _ = self.apiClient.fetchVacation(parameters: paramters) { [weak self] result in
            switch result {
            case let .success(response):
                self?.decisionState = .fetched(response)
            case let .failure(error):
                self?.decisionState = .error(error)
            }
        }
    }
    
    private func handleFetch(response: VacationResponse) {
        self.userInterface?.showTableView()
        self.userInterface?.updateView()
        self.headerViewModel?.availableVacationDays = response.availableVacationDays
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            error.type == .unauthorized
                ? self.errorHandler.throwing(error: error)
                : self.errorViewModel?.update(error: error)
        } else {
            self.errorViewModel?.update(error: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
}
