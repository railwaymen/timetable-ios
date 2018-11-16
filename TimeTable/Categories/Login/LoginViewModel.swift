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
    func tearDown()
    func passwordInputEnabledState(_ isEnabled: Bool)
    func loginButtonEnabledState(_ isEnabled: Bool)
    func focusOnPasswordTextField()
    func checkBoxIsActiveState(_ isActive: Bool)
}

protocol LoginViewModelType: class {
    func viewDidLoad()
    func loginInputValueDidChange(value: String?)
    func loginTextFieldDidRequestForReturn() -> Bool
    func passwordInputValueDidChange(value: String?)
    func passwordTextFieldDidRequestForReturn() -> Bool
    func shouldRemeberUserBoxStatusDidChange(isActive: Bool)
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
    private var shouldRememberLoginCredentilas: Bool = false

    init(userInterface: LoginViewModelOutput, coordinator: LoginCoordinatorDelegate, accessService: AccessServiceLoginCredentialsType,
         contentProvider: LoginContentProviderType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.accessService = accessService
        self.contentProvider = contentProvider
        self.loginCredentials = LoginCredentials(email: "", password: "")
        self.errorHandler = errorHandler
    }
    
    // MARK: - LoginViewModelOutput
    func viewDidLoad() {
        userInterface?.setUpView(checkBoxIsActive: shouldRememberLoginCredentilas)
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
        shouldRememberLoginCredentilas = !isActive
        userInterface?.checkBoxIsActiveState(!isActive)
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
        
        contentProvider.login(with: loginCredentials) { [weak self, credentials = self.loginCredentials,
                                                        shouldSave = self.shouldRememberLoginCredentilas] result in
            
            switch result {
            case .success:
                if shouldSave {
                    self?.save(credentials: credentials)
                }
                self?.coordinator.loginDidFinish(with: .loggedInCorrectly)
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func viewRequestedToChangeServerAddress() {
        userInterface?.tearDown()
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
