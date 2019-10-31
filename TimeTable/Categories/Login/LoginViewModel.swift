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
        userInterface?.setUpView(checkBoxIsActive: shouldRememberLoginCredentials)
        self.userInterface?.updateLoginFields(email: loginCredentials.email, password: loginCredentials.password)
    }
    
    func loginInputValueDidChange(value: String?) {
        guard let loginValue = value else { return }
        loginCredentials.email = loginValue
        updateView()
    }
    
    func loginTextFieldDidRequestForReturn() -> Bool {
        guard !loginCredentials.email.isEmpty else { return false }
        userInterface?.focusOnPasswordTextField()
        return true
    }
    
    func passwordInputValueDidChange(value: String?) {
        guard let passowrdValue = value else { return }
        loginCredentials.password = passowrdValue
        updateView()
    }
    
    func passwordTextFieldDidRequestForReturn() -> Bool {
        let isCorrect = !loginCredentials.email.isEmpty && !loginCredentials.password.isEmpty
        if isCorrect {
            viewRequestedToLogin()
        }
        return isCorrect
    }
    
    func shouldRemeberUserBoxStatusDidChange(isActive: Bool) {
        shouldRememberLoginCredentials = !isActive
        userInterface?.checkBoxIsActiveState(!isActive)
    }
    
    func viewTapped() {
        userInterface?.dismissKeyboard()
    }
    
    func viewRequestedToLogin() {
        guard !loginCredentials.email.isEmpty else {
            errorHandler.throwing(error: UIError.cannotBeEmpty(.loginTextField))
            return
        }
        
        guard !loginCredentials.password.isEmpty else {
            errorHandler.throwing(error: UIError.cannotBeEmpty(.passwordTextField))
            return
        }
        userInterface?.setActivityIndicator(isHidden: false)
        contentProvider.login(
            with: loginCredentials,
            fetchCompletion: { [weak self] result in
                switch result {
                case .success(let session):
                    self?.coordinator.loginDidFinish(with: .loggedInCorrectly(session))
                case .failure(let error):
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
        coordinator.loginDidFinish(with: .changeAddress)
    }
    
    // MARK: - Private
    private func updateView() {
        userInterface?.passwordInputEnabledState((!loginCredentials.password.isEmpty && loginCredentials.email.isEmpty) || !loginCredentials.email.isEmpty)
        userInterface?.loginButtonEnabledState(!loginCredentials.email.isEmpty && !loginCredentials.password.isEmpty)
    }
    
    private func save(credentials: LoginCredentials) {
        do {
            try accessService.saveUser(credentails: credentials)
        } catch {
            errorHandler.throwing(error: error)
        }
    }
}
