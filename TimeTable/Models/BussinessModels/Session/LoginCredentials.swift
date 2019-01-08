//
//  LoginCredentials.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct LoginCredentials: Codable {
    var email: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

// MARK: - Equatable
extension LoginCredentials: Equatable {
    static func == (lhs: LoginCredentials, rhs: LoginCredentials) -> Bool {
        return lhs.email == rhs.email && lhs.password == rhs.password
    }
}
