//
//  LoginViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol LoginViewModelOutput: class {
    func setUpView()
    func tearDown()
    func passwordInputEnabledState(_ isEnabled: Bool)
    func loginButtonEnabledState(_ isEnabled: Bool)
    func focusOnPasswordTextField()
}

protocol LoginViewModelType: class {
    func viewDidLoad()
    func viewWillDisappear()
    func loginInputValueDidChange(value: String?)
    func loginTextFieldDidRequestForReturn() -> Bool
    func passwordInputValueDidChange(value: String?)
    func passwordTextFieldDidRequestForReturn() -> Bool
    func viewRequestedToLogin()
}

class LoginViewModel: LoginViewModelType {
    
    private weak var userInterface: LoginViewModelOutput?
    private let coordinator: LoginCoordinatorDelegate
    private let contentProvider: LoginContentProviderType
    private let errorHandler: ErrorHandlerType
    private var loginCredentials: LoginCredentials

    init(userInterface: LoginViewModelOutput, coordinator: LoginCoordinatorDelegate,
         contentProvider: LoginContentProviderType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.contentProvider = contentProvider
        self.loginCredentials = LoginCredentials(email: "", password: "")
        self.errorHandler = errorHandler
    }
    
    // MARK: - LoginViewModelOutput
    func viewDidLoad() {
        userInterface?.setUpView()
    }
    
    func viewWillDisappear() {
        userInterface?.tearDown()
        coordinator.loginDidFinish()
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
    
    func viewRequestedToLogin() {
        guard !loginCredentials.email.isEmpty else {
            errorHandler.throwing(error: UIError.cannotBeEmpty(.loginTextField))
            return
        }
        
        guard !loginCredentials.password.isEmpty else {
            errorHandler.throwing(error: UIError.cannotBeEmpty(.passwordTextField))
            return
        }
        
        contentProvider.login(with: loginCredentials) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator.loginDidFinishWithSuccess()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    // MARK: - Private
    private func updateView() {
        userInterface?.passwordInputEnabledState((!loginCredentials.password.isEmpty && loginCredentials.email.isEmpty) || !loginCredentials.email.isEmpty)
        userInterface?.loginButtonEnabledState(!loginCredentials.email.isEmpty && !loginCredentials.password.isEmpty)
    }
}
