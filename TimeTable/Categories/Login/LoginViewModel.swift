//
//  LoginViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol LoginViewModelOutput: class {
    func setUpView(checkBoxIsActive: Bool)
    func updateLoginFields(email: String, password: String)
    func passwordInputEnabledState(_ isEnabled: Bool)
    func loginButtonEnabledState(_ isEnabled: Bool)
    func focusOnPasswordTextField()
    func checkBoxIsActiveState(_ isActive: Bool)
    func dismissKeyboard()
    func setActivityIndicator(isHidden: Bool)
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

class LoginViewModel: LoginViewModelType {
    
    private weak var userInterface: LoginViewModelOutput?
    private let coordinator: LoginCoordinatorDelegate
    private let contentProvider: LoginContentProviderType
    private let accessService: AccessServiceLoginCredentialsType
    private let errorHandler: ErrorHandlerType
    private var loginCredentials: LoginCredentials
    private var shouldRememberLoginCredentials: Bool = false

    init(userInterface: LoginViewModelOutput,
         coordinator: LoginCoordinatorDelegate,
         accessService: AccessServiceLoginCredentialsType,
         contentProvider: LoginContentProviderType,
         errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.accessService = accessService
        self.contentProvider = contentProvider
        self.errorHandler = errorHandler
        do {
            self.loginCredentials = try accessService.getUserCredentials()
        } catch {
            self.loginCredentials = LoginCredentials(email: "", password: "")
        }
    }
    
    // MARK: - LoginViewModelOutput
    func viewDidLoad() {
        self.userInterface?.setUpView(checkBoxIsActive: shouldRememberLoginCredentials)
        self.userInterface?.updateLoginFields(email: loginCredentials.email, password: loginCredentials.password)
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
        self.shouldRememberLoginCredentials = !isActive
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
                    self?.coordinator.loginDidFinish(with: .loggedInCorrectly(session))
                case .failure(let error):
                    self?.userInterface?.setActivityIndicator(isHidden: true)
                    self?.errorHandler.throwing(error: error)
                }
            },
            saveCompletion: { [weak self, credentials = self.loginCredentials, shouldSave = self.shouldRememberLoginCredentials] result in
                self?.userInterface?.setActivityIndicator(isHidden: true)
                guard shouldSave else { return }
                switch result {
                case .success:
                    self?.save(credentials: credentials)
                case .failure(let error):
                    self?.errorHandler.throwing(error: AppError.cannotRemeberUserCredentials(error: error))
                }
            })
    }
    
    func viewRequestedToChangeServerAddress() {
        self.coordinator.loginDidFinish(with: .changeAddress)
    }
    
    // MARK: - Private
    private func updateView() {
        let isPasswordEnabled = (!self.loginCredentials.password.isEmpty && self.loginCredentials.email.isEmpty) || !self.loginCredentials.email.isEmpty
        self.userInterface?.passwordInputEnabledState(isPasswordEnabled)
        self.userInterface?.loginButtonEnabledState(!self.loginCredentials.email.isEmpty && !self.loginCredentials.password.isEmpty)
    }
    
    private func save(credentials: LoginCredentials) {
        do {
            try self.accessService.saveUser(credentails: credentials)
        } catch {
            self.errorHandler.throwing(error: error)
        }
    }
}
