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
    func closeButtonTapped()
    func numberOfTypes() -> Int
    func titleOfType(for row: Int) -> String?
    func viewChanged(startAtDate date: Date)
    func viewChanged(endAtDate date: Date)
    func viewSelectedType(at row: Int)
    func noteTextViewDidChanged(text: String)
    func saveButtonTapped()
    func viewHasBeenTapped()
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
    func dismissKeyboard()
}

class NewVacationViewModel {
    private weak var userInterface: NewVacationViewModelOutput?
    private weak var coordinator: NewVacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let notificationCenter: NotificationCenterType
    private let errorHandler: ErrorHandlerType
    private let vacationTypes: [VacationType]
    private let availableVacationDays: Int
    
    private var form: VacationFormType {
        didSet {
            self.updateValidationErrorsOnUI()
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
            case .error:
                self.userInterface?.setActivityIndicator(isHidden: true)
            }
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: NewVacationViewModelOutput,
        apiClient: ApiClientVacationType,
        errorHandler: ErrorHandlerType,
        notificationCenter: NotificationCenterType,
        availableVacationDays: Int,
        coordinator: NewVacationCoordinatorDelegate
    ) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.notificationCenter = notificationCenter
        self.coordinator = coordinator
        self.availableVacationDays = availableVacationDays
        self.vacationTypes = VacationType.allCases
        self.decisionState = .preparing
        self.form = VacationForm()
        self.setUpNotification()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func keyboardFrameWillChange(_ notification: NSNotification) {
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight = userInfo?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
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
    
    func noteTextViewDidChanged(text: String) {
        self.form.note = text
    }
    
    func saveButtonTapped() {
        self.decisionState = .request
        self.postVacation()
    }
    
    func viewHasBeenTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - Private
extension NewVacationViewModel {
    private func setUpNotification() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardFrameWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
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
            _ = self.apiClient.addVacation(vacation: vacation) { [weak self] result in
                switch result {
                case let .success(response):
                    self?.decisionState = .done(response)
                case let .failure(error):
                    self?.decisionState = .error(error)
                }
            }
        } catch {
            self.updateValidationErrorsOnUI()
        }
    }
    
    private func updateValidationErrorsOnUI() {
        let errors = self.form.validationErrors()
        self.userInterface?.setSaveButton(isEnabled: errors.isEmpty)
        self.userInterface?.setNote(isHighlighted: errors.contains(.noteIsNil))
    }
}
