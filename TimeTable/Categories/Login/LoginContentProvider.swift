//
//  LoginContentProvider.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
protocol LoginContentProviderType: class {
    func login(with credentials: LoginCredentials, completion: @escaping ((Result<Void>) -> Void))
}

class LoginContentProvider: LoginContentProviderType {

    // MARK: - LoginContentProviderType
    func login(with credentials: LoginCredentials, completion: @escaping ((Result<Void>) -> Void)) {
        completion(.success(Void()))
    }
}
