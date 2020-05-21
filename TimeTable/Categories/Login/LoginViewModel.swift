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
    func updateColors()
    func updateLoginFields(email: String, password: String)
    func loginButtonEnabledState(_ isEnabled: Bool)
    func focusOnPasswordTextField()
    func checkBoxIsActiveState(_ isActive: Bool)
    func dismissKeyboard()
    func setActivityIndicator(isHidden: Bool)
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState)
}

protocol LoginViewModelType: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDisappear()
    func viewShouldUpdateColors()
    func loginInputValueDidChange(value: String?)
    func loginTextFieldDidRequestForReturn() -> Bool
    func passwordInputValueDidChange(value: String?)
    func passwordTextFieldDidRequestForReturn() -> Bool
    func shouldRememberUserBoxStatusDidChange(isActive: Bool)
    func viewTapped()
    func viewRequestedToLogin()
    func viewRequestedToChangeServerAddress()
}

class LoginViewModel: KeyboardManagerObserverable {
    private weak var userInterface: LoginViewModelOutput?
    private weak var coordinator: LoginCoordinatorDelegate?
    private let contentProvider: LoginContentProviderType
    private let errorHandler: ErrorHandlerType
    private let keyboardManager: KeyboardManagerable?
    
    private var loginForm: LoginFormType {
        didSet {
            self.updateLogInButton()
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: LoginViewModelOutput,
        coordinator: LoginCoordinatorDelegate,
        contentProvider: LoginContentProviderType,
        errorHandler: ErrorHandlerType,
        loginForm: LoginFormType = LoginForm(),
        keyboardManager: KeyboardManagerable
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        self.loginForm = loginForm
        self.keyboardManager = keyboardManager
    }
}

// MARK: - LoginViewModelType
extension LoginViewModel: LoginViewModelType {
    func viewDidLoad() {
        self.contentProvider.closeSession()
        self.userInterface?.setUpView(checkBoxIsActive: self.loginForm.shouldRememberUser)
        self.userInterface?.updateLoginFields(email: self.loginForm.email, password: self.loginForm.password)
        self.updateLogInButton()
    }
    
    func viewWillAppear() {
        self.keyboardManager?.setKeyboardStateChangeHandler(for: self) { [weak userInterface] state in
            userInterface?.keyboardStateDidChange(to: state)
        }
    }
    
    func viewDidDisappear() {
        self.keyboardManager?.removeHandler(for: self)
    }
    
    func viewShouldUpdateColors() {
        self.userInterface?.updateColors()
    }
    
    func loginInputValueDidChange(value: String?) {
        guard let email = value else { return }
        self.loginForm.email = email
    }
    
    func loginTextFieldDidRequestForReturn() -> Bool {
        guard !self.loginForm.email.isEmpty else { return false }
        self.userInterface?.focusOnPasswordTextField()
        return true
    }
    
    func passwordInputValueDidChange(value: String?) {
        guard let password = value else { return }
        self.loginForm.password = password
    }
    
    func passwordTextFieldDidRequestForReturn() -> Bool {
        if self.loginForm.isValid {
            self.viewRequestedToLogin()
        }
        return self.loginForm.isValid
    }
    
    func shouldRememberUserBoxStatusDidChange(isActive: Bool) {
        let newValue = !isActive
        self.loginForm.shouldRememberUser = newValue
        self.userInterface?.checkBoxIsActiveState(newValue)
    }
    
    func viewTapped() {
        self.userInterface?.dismissKeyboard()
    }
    
    func viewRequestedToLogin() {
        do {
            let credentials = try self.loginForm.generateEncodableObject()
            self.login(with: credentials)
        } catch {
            self.updateLogInButton()
        }
    }
    
    func viewRequestedToChangeServerAddress() {
        self.coordinator?.loginDidFinish(with: .changeAddress)
    }
}

// MARK: - Private
extension LoginViewModel {
    private func updateLogInButton() {
        self.userInterface?.loginButtonEnabledState(self.loginForm.isValid)
    }
    
    private func login(with credentials: LoginCredentials) {
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.contentProvider.login(
            with: credentials,
            shouldSaveUser: self.loginForm.shouldRememberUser) { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.loginDidFinish(with: .loggedInCorrectly)
                case let .failure(error):
                    self?.handleLoginFailure(error: error)
                }
        }
    }
    
    private func handleLoginFailure(error: Error) {
        self.userInterface?.setActivityIndicator(isHidden: true)
        self.errorHandler.throwing(error: error)
    }
}
