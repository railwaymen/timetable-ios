//
//  LoginContentProvider.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore

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
                self?.save(userDecoder: userDecoder, completion: { result in
                    switch result {
                    case .success:
                        completion(.success(Void()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    private func save(userDecoder: SessionDecoder, completion: @escaping ((Result<UserEntity>) -> Void)) {
        coreDataStack.save(userDecoder: userDecoder, coreDataTypeTranslation: { (transaction: AsynchronousDataTransactionType) -> UserEntity in
            _ = transaction.deleteAll(From<UserEntity>())
            return UserEntity.createUser(from: userDecoder, transaction: transaction)
        }) { result in
            switch result {
            case .success(let entity):
                completion(.success(entity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
