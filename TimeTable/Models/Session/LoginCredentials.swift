//
//  LoginCredentials.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct LoginCredentials: Encodable {
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
