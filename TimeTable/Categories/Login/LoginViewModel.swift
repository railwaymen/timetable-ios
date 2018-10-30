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
    private var loginCredentials: LoginCredentials
    
    private struct LoginCredentials {
        var login: String
        var passowrd: String
        
        var passwordIsEnabled: Bool {
            return (!passowrd.isEmpty && login.isEmpty) || !login.isEmpty
        }
        var isCorrectCredentials: Bool {
            return !login.isEmpty && !passowrd.isEmpty
        }
    }
    
    init(userInterface: LoginViewModelOutput) {
        self.userInterface = userInterface
        self.loginCredentials = LoginCredentials(login: "", passowrd: "")
    }
    
    // MARK: - LoginViewModelOutput
    func viewDidLoad() {
        userInterface?.setUpView()
    }
    
    func viewWillDisappear() {
        userInterface?.tearDown()
    }
    
    func loginInputValueDidChange(value: String?) {
        guard let loginValue = value else { return }
        loginCredentials.login = loginValue
        updateView()
    }
    
    func loginTextFieldDidRequestForReturn() -> Bool {
        return !loginCredentials.login.isEmpty
    }
    
    func passwordInputValueDidChange(value: String?) {
        guard let passowrdValue = value else { return }
        loginCredentials.passowrd = passowrdValue
        updateView()
    }
    
    func passwordTextFieldDidRequestForReturn() -> Bool {
        return !loginCredentials.passowrd.isEmpty
    }
    
    func viewRequestedToLogin() {
        
    }
    
    // MARK: - Private
    private func updateView() {
        userInterface?.passwordInputEnabledState(loginCredentials.passwordIsEnabled)
        userInterface?.loginButtonEnabledState(loginCredentials.isCorrectCredentials)
    }
}
