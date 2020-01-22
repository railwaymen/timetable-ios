//
//  LoginViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol LoginViewModelOutput: class {
    func setUpView(checkBoxIsActive: Bool)
    func updateLoginFields(email: String, password: String)
    func passwordInputEnabledState(_ isEnabled: Bool)
    func loginButtonEnabledState(_ isEnabled: Bool)
    func focusOnPasswordTextField()
    func checkBoxIsActiveState(_ isActive: Bool)
    func dismissKeyboard()
    func setActivityIndicator(isHidden: Bool)
    func setBottomContentInset(_ height: CGFloat)
}

protocol LoginViewModelType: class {
    func viewDidLoad()
    func loginInputValueDidChange(value: String?)
    func loginTextFieldDidRequestForReturn() -> Bool
    func passwordInputValueDidChange(value: String?)
    func passwordTextFieldDidRequestForReturn() -> Bool
    func shouldRemeberUserBoxStatusDidChange(isActive: Bool)
    func viewTapped()
    func viewRequestedToLogin()
    func viewRequestedToChangeServerAddress()
}

class LoginViewModel {
    private weak var userInterface: LoginViewModelOutput?
    private weak var coordinator: LoginCoordinatorDelegate?
    private let contentProvider: LoginContentProviderType
    private let accessService: AccessServiceLoginCredentialsType
    private let errorHandler: ErrorHandlerType
    private let notificationCenter: NotificationCenterType
    
    private var loginCredentials: LoginCredentials
    
    // MARK: - Initialization
    init(
        userInterface: LoginViewModelOutput,
        coordinator: LoginCoordinatorDelegate,
        accessService: AccessServiceLoginCredentialsType,
        contentProvider: LoginContentProviderType,
        errorHandler: ErrorHandlerType,
        notificationCenter: NotificationCenterType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.accessService = accessService
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.notificationCenter = notificationCenter
        self.loginCredentials = LoginCredentials(email: "", password: "")
        
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func changeKeyboardFrame(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
    }
}

// MARK: - LoginViewModelType
extension LoginViewModel: LoginViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUpView(checkBoxIsActive: false)
        self.userInterface?.updateLoginFields(email: self.loginCredentials.email, password: self.loginCredentials.password)
    }
    
    func loginInputValueDidChange(value: String?) {
        guard let loginValue = value else { return }
        self.loginCredentials.email = loginValue
        self.updateView()
    }
    
    func loginTextFieldDidRequestForReturn() -> Bool {
        guard !self.loginCredentials.email.isEmpty else { return false }
        self.userInterface?.focusOnPasswordTextField()
        return true
    }
    
    func passwordInputValueDidChange(value: String?) {
        guard let passowrdValue = value else { return }
        self.loginCredentials.password = passowrdValue
        self.updateView()
    }
    
    func passwordTextFieldDidRequestForReturn() -> Bool {
        let isCorrect = !self.loginCredentials.email.isEmpty && !self.loginCredentials.password.isEmpty
        if isCorrect {
            self.viewRequestedToLogin()
        }
        return isCorrect
    }
    
    func shouldRemeberUserBoxStatusDidChange(isActive: Bool) {
        self.userInterface?.checkBoxIsActiveState(!isActive)
    }
    
    func viewTapped() {
        self.userInterface?.dismissKeyboard()
    }
    
    func viewRequestedToLogin() {
        guard !self.loginCredentials.email.isEmpty else {
            self.errorHandler.throwing(error: UIError.cannotBeEmpty(.loginTextField))
            return
        }
        
        guard !self.loginCredentials.password.isEmpty else {
            self.errorHandler.throwing(error: UIError.cannotBeEmpty(.passwordTextField))
            return
        }
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.contentProvider.login(
            with: self.loginCredentials,
            fetchCompletion: { [weak self] result in
                switch result {
                case .success(let session):
                    self?.coordinator?.loginDidFinish(with: .loggedInCorrectly(session))
                case .failure(let error):
                    self?.userInterface?.setActivityIndicator(isHidden: true)
                    self?.errorHandler.throwing(error: error)
                }
            },
            saveCompletion: { [weak self] result in
                self?.userInterface?.setActivityIndicator(isHidden: true)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    self?.errorHandler.throwing(error: AppError.cannotRemeberUserCredentials(error: error))
                }
            })
    }
    
    func viewRequestedToChangeServerAddress() {
        self.coordinator?.loginDidFinish(with: .changeAddress)
    }
}

// MARK: - Private
extension LoginViewModel {
    private func setUpNotifications() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    private func updateView() {
        let isPasswordEnabled = (!self.loginCredentials.password.isEmpty && self.loginCredentials.email.isEmpty) || !self.loginCredentials.email.isEmpty
        self.userInterface?.passwordInputEnabledState(isPasswordEnabled)
        self.userInterface?.loginButtonEnabledState(!self.loginCredentials.email.isEmpty && !self.loginCredentials.password.isEmpty)
    }
}
