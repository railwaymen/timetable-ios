//
//  LoginForm.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 04/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol LoginFormType {
    var email: String { get set }
    var password: String { get set }
    var shouldRememberUser: Bool { get set }
    
    var isValid: Bool { get }
    
    func generateEncodableObject() throws -> LoginCredentials
    func validationErrors() -> [LoginForm.ValidationError]
}

struct LoginForm: LoginFormType {
    var email: String
    var password: String
    var shouldRememberUser: Bool
    
    var isValid: Bool {
        self.validationErrors().isEmpty
    }
    
    // MARK: - Initialization
    init(
        email: String = "",
        password: String = "",
        shouldRememberUser: Bool = false
    ) {
        self.email = email
        self.password = password
        self.shouldRememberUser = shouldRememberUser
    }
    
    // MARK: - Internal
    func generateEncodableObject() throws -> LoginCredentials {
        if let error = self.validationErrors().first {
            throw error
        }
        return LoginCredentials(
            email: self.email,
            password: self.password)
    }
    
    func validationErrors() -> [ValidationError] {
        var errors: [ValidationError] = []
        if self.email.isEmpty { errors.append(.emailEmpty) }
        if self.password.isEmpty { errors.append(.passwordEmpty) }
        return errors
    }
}

// MARK: - Structures
extension LoginForm {
    enum ValidationError: Error {
        case emailEmpty
        case passwordEmpty
    }
}
