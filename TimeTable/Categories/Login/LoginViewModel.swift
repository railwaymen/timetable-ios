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
    private let errorHandler: ErrorHandlerType
    private let notificationCenter: NotificationCenterType
    
    private var loginCredentials: LoginCredentials
    private var shouldRememberUser: Bool = false
    
    // MARK: - Initialization
    init(
        userInterface: LoginViewModelOutput,
        coordinator: LoginCoordinatorDelegate,
        contentProvider: LoginContentProviderType,
        errorHandler: ErrorHandlerType,
        notificationCenter: NotificationCenterType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
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
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight = userInfo?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
    }
}

// MARK: - LoginViewModelType
extension LoginViewModel: LoginViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUpView(checkBoxIsActive: self.shouldRememberUser)
        self.userInterface?.updateLoginFields(email: self.loginCredentials.email, password: self.loginCredentials.password)
        self.updateLogInButton()
    }
    
    func loginInputValueDidChange(value: String?) {
        guard let loginValue = value else { return }
        self.loginCredentials.email = loginValue
        self.updateLogInButton()
    }
    
    func loginTextFieldDidRequestForReturn() -> Bool {
        guard !self.loginCredentials.email.isEmpty else { return false }
        self.userInterface?.focusOnPasswordTextField()
        return true
    }
    
    func passwordInputValueDidChange(value: String?) {
        guard let passowrdValue = value else { return }
        self.loginCredentials.password = passowrdValue
        self.updateLogInButton()
    }
    
    func passwordTextFieldDidRequestForReturn() -> Bool {
        let isCorrect = !self.loginCredentials.email.isEmpty && !self.loginCredentials.password.isEmpty
        if isCorrect {
            self.viewRequestedToLogin()
        }
        return isCorrect
    }
    
    func shouldRemeberUserBoxStatusDidChange(isActive: Bool) {
        let newValue = !isActive
        self.shouldRememberUser = newValue
        self.userInterface?.checkBoxIsActiveState(newValue)
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
            shouldSaveUser: self.shouldRememberUser) { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.loginDidFinish(with: .loggedInCorrectly)
                case let .failure(error):
                    self?.userInterface?.setActivityIndicator(isHidden: true)
                    if let apiError = error as? ApiClientError {
                        switch apiError.type {
                        case .validationErrors:
                            self?.errorHandler.throwing(error: UIError.loginCredentialsInvalid)
                        default:
                            self?.errorHandler.throwing(error: error)
                        }
                    } else {
                        self?.errorHandler.throwing(error: error)
                    }
                }
        }
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
    
    private func updateLogInButton() {
        let isLoginButtonEnabled = !self.loginCredentials.email.isEmpty && !self.loginCredentials.password.isEmpty
        self.userInterface?.loginButtonEnabledState(isLoginButtonEnabled)
    }
}
