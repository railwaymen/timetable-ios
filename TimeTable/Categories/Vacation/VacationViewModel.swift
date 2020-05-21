//
//  VacationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol VacationViewModelOutput: class {
    func setUpView()
    func showTableView()
    func showErrorView()
    func setActivityIndicator(isHidden: Bool)
    func updateView()
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState)
    func dismissKeyboard()
}

protocol VacationViewModelType: class {
    func loadView()
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDisappear()
    func viewRequestForVacationForm()
    func viewRequestForProfileView()
    func refreshControlDidActivate(completion: @escaping () -> Void)
    func viewTapped()
    func isAbleToDeclineVacation(at index: IndexPath) -> Bool
    func viewRequestToDeclineVacation(at index: IndexPath, completion: @escaping (Bool) -> Void)
    func numberOfItems() -> Int
    func configure(_ cell: VacationCellable, for indexPath: IndexPath)
    func configure(_ view: VacationTableHeaderViewable)
    func configure(_ view: ErrorViewable)
}

class VacationViewModel: KeyboardManagerObserverable {
    private weak var userInterface: VacationViewModelOutput?
    private weak var coordinator: VacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let errorHandler: ErrorHandlerType
    private let keyboardManager: KeyboardManagerable
    
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
            case .refresh:
                break
            }
        }
    }
    
    private var availableVacationDays: Int {
        switch self.decisionState {
        case let .fetched(response): return response.availableVacationDays
        case .error, .fetching, .refresh: return 0
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: VacationViewModelOutput,
        coordinator: VacationCoordinatorDelegate,
        apiClient: ApiClientVacationType,
        errorHandler: ErrorHandlerType,
        keyboardManager: KeyboardManagerable
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.keyboardManager = keyboardManager
        
        self.selectedYear = Calendar.autoupdatingCurrent.component(.year, from: Date())
    }
}

// MARK: - Structures
extension VacationViewModel {
    enum DecisionState {
        case fetching
        case refresh
        case error(Error)
        case fetched(VacationResponse)
    }
}

// MARK: - VacationViewModelType
extension VacationViewModel: VacationViewModelType {
    func loadView() {
        self.userInterface?.setUpView()
    }
    
    func viewDidLoad() {
        self.fetchVacation()
    }
    
    func viewWillAppear() {
        self.keyboardManager.setKeyboardStateChangeHandler(for: self) { [weak userInterface] state in
            userInterface?.keyboardStateDidChange(to: state)
        }
    }
    
    func viewDidDisappear() {
        self.keyboardManager.removeHandler(for: self)
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
    
    func refreshControlDidActivate(completion: @escaping () -> Void) {
        self.fetchVacation(decisionState: .refresh, completion: completion)
    }
    
    func viewTapped() {
        self.userInterface?.dismissKeyboard()
    }
    
    func isAbleToDeclineVacation(at index: IndexPath) -> Bool {
        guard let vacation = self.item(at: index) else { return false }
        return vacation.status == .unconfirmed
    }
    
    func viewRequestToDeclineVacation(at index: IndexPath, completion: @escaping (Bool) -> Void) {
        guard let vacation = self.item(at: index) else { return completion(false) }
        self.userInterface?.setActivityIndicator(isHidden: false)
        _ = self.apiClient.declineVacation(vacation) { [weak self] result in
            guard let self = self else { return completion(false) }
            self.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success:
                self.fetchVacation()
                completion(true)
            case let .failure(error):
                self.errorHandler.throwing(error: error)
                completion(false)
            }
        }
    }
    
    func numberOfItems() -> Int {
        switch self.decisionState {
        case let .fetched(response): return response.records.count
        case .error, .fetching, .refresh: return 0
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
        let viewModel = ErrorViewModel(userInterface: view, localizedError: UIError.genericError) { [weak self] in
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
        case .error, .fetching, .refresh: break
        }
    }
    
    private func item(at index: IndexPath) -> VacationDecoder? {
        switch self.decisionState {
        case let .fetched(response): return response.records[safeIndex: index.row]
        case .error, .fetching, .refresh: return nil
        }
    }
    
    private func fetchVacation(decisionState: DecisionState = .fetching, completion: (() -> Void)? = nil) {
        self.decisionState = decisionState
        let parameters = VacationParameters(year: self.selectedYear)
        _ = self.apiClient.fetchVacation(parameters: parameters) { [weak self] result in
            defer { completion?() }
            switch result {
            case let .success(response):
                self?.decisionState = .fetched(response)
            case let .failure(error):
                self?.decisionState = .error(error)
            }
        }
    }
    
    private func handleFetch(response: VacationResponse) {
        self.userInterface?.updateView()
        self.headerViewModel?.availableVacationDays = response.availableVacationDays
        self.userInterface?.showTableView()
    }
    
    private func handleFetch(error: Error) {
        if let error = error as? ApiClientError {
            error.type == .unauthorized
                ? self.errorHandler.throwing(error: error)
                : self.errorViewModel?.update(localizedError: error)
        } else {
            self.errorViewModel?.update(localizedError: UIError.genericError)
            self.errorHandler.throwing(error: error)
        }
        self.userInterface?.showErrorView()
    }
}
