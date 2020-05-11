//
//  NewVacationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol NewVacationViewModelType: class {
    func loadView()
    func viewWillAppear()
    func viewDidDisappear()
    func closeButtonTapped()
    func numberOfTypes() -> Int
    func titleOfType(for row: Int) -> String?
    func viewChanged(startAtDate date: Date)
    func viewChanged(endAtDate date: Date)
    func viewSelectedType(at row: Int)
    func noteTextViewDidChange(text: String)
    func saveButtonTapped()
    func viewTapped()
}

protocol NewVacationViewModelOutput: class {
    func setUp(availableVacationDays: String)
    func setActivityIndicator(isHidden: Bool)
    func setNote(text: String)
    func setMinimumDateForStartDate(minDate: Date)
    func setMinimumDateForEndDate(minDate: Date)
    func updateStartDate(with date: Date, dateString: String)
    func updateEndDate(with date: Date, dateString: String)
    func updateType(name: String)
    func setSaveButton(isEnabled: Bool)
    func setBottomContentInset(_ height: CGFloat)
    func setNote(isHighlighted: Bool)
    func setOptionalLabel(isHidden: Bool)
    func dismissKeyboard()
}

class NewVacationViewModel: KeyboardManagerObserverable {
    private weak var userInterface: NewVacationViewModelOutput?
    private weak var coordinator: NewVacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let errorHandler: ErrorHandlerType
    private let keyboardManager: KeyboardManagerable
    private let vacationTypes: [VacationType]
    private let availableVacationDays: Int
    
    private var form: VacationFormType {
        didSet {
            self.updateUI()
            self.updateUIStaticComponents()
        }
    }
    
    private var decisionState: DecistionState {
        didSet {
            switch self.decisionState {
            case .preparing:
                self.updateViewForPreparingState()
            case .request:
                self.userInterface?.setActivityIndicator(isHidden: false)
            case let .done(response):
                self.userInterface?.setActivityIndicator(isHidden: true)
                self.coordinator?.finishFlow(response: response)
            case let .error(error):
                self.userInterface?.setActivityIndicator(isHidden: true)
                self.handleResponse(error: error)
            }
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: NewVacationViewModelOutput,
        coordinator: NewVacationCoordinatorDelegate,
        apiClient: ApiClientVacationType,
        errorHandler: ErrorHandlerType,
        keyboardManager: KeyboardManagerable,
        availableVacationDays: Int
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.keyboardManager = keyboardManager
        self.availableVacationDays = availableVacationDays
        
        self.vacationTypes = VacationType.allCases
        self.decisionState = .preparing
        self.form = VacationForm()
    }
}

// MARK: - Structures
extension NewVacationViewModel {
    enum DecistionState {
        case preparing
        case request
        case done(VacationDecoder)
        case error(Error)
    }
}

// MARK: - NewVacationViewModelType
extension NewVacationViewModel: NewVacationViewModelType {
    func loadView() {
        self.userInterface?.setUp(availableVacationDays: "\(self.availableVacationDays)")
        self.decisionState = .preparing
    }
    
    func viewWillAppear() {
        self.keyboardManager.setKeyboardHeightChangeHandler(for: self) { [weak userInterface] keyboardHeight in
            userInterface?.setBottomContentInset(keyboardHeight)
        }
    }
    
    func viewDidDisappear() {
        self.keyboardManager.removeHandler(for: self)
    }
    
    func closeButtonTapped() {
        self.coordinator?.finishFlow(response: nil)
    }
    
    func numberOfTypes() -> Int {
        return self.vacationTypes.count
    }
    
    func titleOfType(for row: Int) -> String? {
        return self.vacationTypeTitle(for: row)
    }
    
    func viewChanged(startAtDate date: Date) {
        self.form.startDate = date
        self.updateDateInput(with: date, action: self.userInterface?.updateStartDate)
        self.userInterface?.setMinimumDateForEndDate(minDate: date)
        guard self.form.endDate < date else { return }
        self.viewChanged(endAtDate: date)
    }
    
    func viewChanged(endAtDate date: Date) {
        self.form.endDate = date
        self.updateDateInput(with: date, action: self.userInterface?.updateEndDate)
    }
    
    func viewSelectedType(at row: Int) {
        guard let type = self.vacationTypes[safeIndex: row] else { return }
        self.form.type = type
        self.userInterface?.updateType(name: type.localizableString)
    }
    
    func noteTextViewDidChange(text: String) {
        self.form.note = text
    }
    
    func saveButtonTapped() {
        self.postVacation()
    }
    
    func viewTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - Private
extension NewVacationViewModel {
    private func updateDateInput(with date: Date, action: ((Date, String) -> Void)?) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        action?(date, dateString)
    }
    
    private func vacationTypeTitle(for row: Int) -> String {
        guard let type = self.vacationTypes[safeIndex: row] else { return "" }
        return type.localizableString
    }
    
    private func updateViewForPreparingState() {
        self.userInterface?.updateType(name: self.form.type.localizableString)
        let date = Date()
        self.updateDateInput(with: date, action: self.userInterface?.updateStartDate)
        self.updateDateInput(with: date, action: self.userInterface?.updateEndDate)
        self.userInterface?.setMinimumDateForEndDate(minDate: date)
        self.userInterface?.setMinimumDateForStartDate(minDate: date)
        self.userInterface?.setNote(text: "")
        self.userInterface?.setSaveButton(isEnabled: true)
    }
    
    private func postVacation() {
        do {
            let vacation = try self.form.convertToEncoder()
            self.decisionState = .request
            _ = self.apiClient.addVacation(vacation) { [weak self] result in
                switch result {
                case let .success(response):
                    self?.decisionState = .done(response)
                case let .failure(error):
                    self?.decisionState = .error(error)
                }
            }
        } catch {
            self.updateUI()
        }
    }
    
    private func handleResponse(error: Error) {
        if let apiError = error as? ApiClientError {
            switch apiError.type {
            case let .validationErrors(base):
                guard let base = base, base.errors.keys.contains(where: { $0.errorKey == .workTimeExists }) else { fallthrough }
                self.errorHandler.throwing(error: error)
            default:
                self.errorHandler.throwing(error: UIError.genericError)
            }
        } else {
            self.errorHandler.throwing(error: error)
        }
    }
    
    private func updateUI() {
        let errors = self.form.validationErrors()
        self.userInterface?.setSaveButton(isEnabled: errors.isEmpty)
        self.updateUI(with: errors)
    }
    
    private func updateUI(with errors: [UIError]) {
        self.userInterface?.setNote(isHighlighted: errors.contains(.cannotBeEmpty(.noteTextView)))
    }
    
    private func updateUIStaticComponents() {
        self.userInterface?.setOptionalLabel(isHidden: !self.form.isNoteOptional)
    }
}
