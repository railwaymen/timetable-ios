//
//  ApiClient+Session.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientSessionType: class {
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void))
}

// MARK: - ApiClientSessionType
extension ApiClient: ApiClientSessionType {
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        post(Endpoints.signIn, parameters: credentials, completion: completion)
    }
}
