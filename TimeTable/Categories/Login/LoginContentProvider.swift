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

    private let apiClient: ApiClientSessionType
    
    // MARK: - Initialization
    init(apiClient: ApiClientSessionType) {
        self.apiClient = apiClient
    }
    
    // MARK: - LoginContentProviderType
    func login(with credentials: LoginCredentials, completion: @escaping ((Result<Void>) -> Void)) {
        apiClient.signIn(with: credentials) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
