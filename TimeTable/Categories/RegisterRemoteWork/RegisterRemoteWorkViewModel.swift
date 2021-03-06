//
//  RegisterRemoteWorkViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol RegisterRemoteWorkViewModelOutput: class {
    func setUp()
    func setUp(title: String)
    func updateColors()
    func setActivityIndicator(isAnimating: Bool)
    func setNote(text: String)
    func setMinimumDateForEndDate(minDate: Date)
    func updateStartDate(with date: Date, dateString: String)
    func updateEndDate(with date: Date, dateString: String)
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState)
    func dismissKeyboard()
    func setSaveButton(isEnabled: Bool)
    func setStartsAt(isHighlighted: Bool)
    func setEndsAt(isHighlighted: Bool)
}

protocol RegisterRemoteWorkViewModelType: class {
    func loadView()
    func viewWillAppear()
    func viewDidDisappear()
    func viewShouldUpdateColors()
    func closeButtonTapped()
    func viewChanged(startAtDate date: Date)
    func viewChanged(endAtDate date: Date)
    func noteTextViewDidChange(text: String)
    func saveButtonTapped()
    func viewTapped()
}

class RegisterRemoteWorkViewModel: KeyboardManagerObserverable {
    private weak var userInterface: RegisterRemoteWorkViewModelOutput?
    private weak var coordinator: RegisterRemoteWorkCoordinatorType?
    private let apiClient: ApiClientRemoteWorkType
    private let errorHandler: ErrorHandlerType
    private let keyboardManager: KeyboardManagerable
    private let mode: Mode
    
    private var form: RemoteWorkFormType {
        didSet {
            self.updateUI()
        }
    }
    
    private var decisionState: DecistionState? {
        didSet {
            switch self.decisionState {
            case .request:
                self.userInterface?.setActivityIndicator(isAnimating: true)
            case let .done(response):
                self.userInterface?.setActivityIndicator(isAnimating: false)
                self.coordinator?.registerRemoteWorkDidFinish(response: response)
            case let .error(error):
                self.userInterface?.setActivityIndicator(isAnimating: false)
                self.handleResponse(error: error)
            case .none: break
            }
        }
    }
    
    private var canSaveEntry: Bool {
        switch self.decisionState {
        case .done, .request:
            return false
        case .error, .none:
            return true
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: RegisterRemoteWorkViewModelOutput,
        coordinator: RegisterRemoteWorkCoordinatorType,
        apiClient: ApiClientRemoteWorkType,
        errorHandler: ErrorHandlerType,
        keyboardManager: KeyboardManagerable,
        mode: Mode
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.keyboardManager = keyboardManager
        self.mode = mode
        self.form = mode.preferredForm
    }
}

// MARK: - Structures
extension RegisterRemoteWorkViewModel {
    enum Mode: Equatable {
        case newEntry
        case editEntry(RemoteWork)
        
        var preferredForm: RemoteWorkForm {
            switch self {
            case .newEntry:
                let startsAt = Date().roundedToQuarter()
                let endsAt = startsAt.addingTimeInterval(.hour)
                return RemoteWorkForm(startsAt: startsAt, endsAt: endsAt)
            case let .editEntry(remoteWork):
                return RemoteWorkForm(remoteWork: remoteWork)
            }
        }
        
        var title: String {
            switch self {
            case .newEntry: return R.string.localizable.registerremotework_create_title()
            case .editEntry: return R.string.localizable.registerremotework_edit_title()
            }
        }
    }
    
    private enum DecistionState {
        case request
        case done([RemoteWork])
        case error(Error)
    }
}

// MARK: - RegisterRemoteWorkViewModelType
extension RegisterRemoteWorkViewModel: RegisterRemoteWorkViewModelType {
    func loadView() {
        self.userInterface?.setUp()
        self.userInterface?.setUp(title: self.mode.title)
        self.updateViewForPreparingState()
    }
    
    func viewWillAppear() {
        self.keyboardManager.setKeyboardStateChangeHandler(for: self) { [weak userInterface] state in
            userInterface?.keyboardStateDidChange(to: state)
        }
    }
    
    func viewDidDisappear() {
        self.keyboardManager.removeHandler(for: self)
    }
    
    func viewShouldUpdateColors() {
        self.userInterface?.updateColors()
        self.updateUI()
    }
    
    func closeButtonTapped() {
        self.coordinator?.registerRemoteWorkDidFinish()
    }
    
    func viewChanged(startAtDate date: Date) {
        self.form.startsAt = date
        self.userInterface?.setMinimumDateForEndDate(minDate: date)
        guard self.form.endsAt < date else { return }
        self.viewChanged(endAtDate: date)
    }
    
    func viewChanged(endAtDate date: Date) {
        self.form.endsAt = date
    }
    
    func noteTextViewDidChange(text: String) {
        self.form.note = text
    }
    
    func saveButtonTapped() {
        do {
            let parameters = try self.form.convertToEncoder()
            self.saveRemoteWork(parameters: parameters)
        } catch {
            self.updateUI()
        }
    }
    
    func viewTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - Private
extension RegisterRemoteWorkViewModel {
    private func updateViewForPreparingState() {
        self.userInterface?.setNote(text: self.form.note)
        self.userInterface?.setMinimumDateForEndDate(minDate: self.form.startsAt)
        self.updateUI()
    }
    
    private func updateDateInput(with date: Date, action: ((Date, String) -> Void)?) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        action?(date, dateString)
    }
    
    private func saveRemoteWork(parameters: RemoteWorkRequest) {
        guard self.canSaveEntry else { return }
        switch self.mode {
        case .newEntry:
            self.postRemoteWork(parameters: parameters)
        case let .editEntry(remoteWork):
            self.updateRemoteWork(remoteWork, parameters: parameters)
        }
    }
    
    private func postRemoteWork(parameters: RemoteWorkRequest) {
        self.decisionState = .request
        _ = apiClient.registerRemoteWork(parameters: parameters) { [weak self] result in
            switch result {
            case let .success(response):
                self?.decisionState = .done(response)
            case let .failure(error):
                self?.decisionState = .error(error)
            }
        }
    }
    
    private func updateRemoteWork(_ remoteWork: RemoteWork, parameters: RemoteWorkRequest) {
        self.decisionState = .request
        _ = apiClient.updateRemoteWork(remoteWork, with: parameters) { [weak self] result in
            switch result {
            case let .success(response):
                self?.decisionState = .done([response])
            case let .failure(error):
                self?.decisionState = .error(error)
            }
        }
    }
    
    private func handleResponse(error: Error) {
        self.errorHandler.throwing(error: error)
    }
    
    private func updateUI() {
        let errors = self.form.validationErrors()
        self.userInterface?.setSaveButton(isEnabled: errors.isEmpty)
        self.updateUI(with: errors)
        self.updateDateInput(with: self.form.startsAt, action: self.userInterface?.updateStartDate)
        self.updateDateInput(with: self.form.endsAt, action: self.userInterface?.updateEndDate)
    }
    
    private func updateUI(with errors: [UIError]) {
        self.userInterface?.setStartsAt(isHighlighted: errors.contains(.remoteWorkStartsAtIncorrectHours))
        self.userInterface?.setEndsAt(isHighlighted: errors.contains(.remoteWorkStartsAtIncorrectHours))
    }
}
