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
    private let coreDataStack: CoreDataStackUserType
    
    // MARK: - Initialization
    init(apiClient: ApiClientSessionType, coreDataStack: CoreDataStackUserType) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - LoginContentProviderType
    func login(with credentials: LoginCredentials, completion: @escaping ((Result<Void>) -> Void)) {
        apiClient.signIn(with: credentials) { [weak self] result in
            switch result {
            case .success(let userDecoder):
                self?.save(userDecoder: userDecoder, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    private func save(userDecoder: SessionDecoder, completion: @escaping ((Result<Void>) -> Void)) {
        coreDataStack.save(userDecoder: userDecoder, completion: completion)
    }
}
