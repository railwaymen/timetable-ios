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
    func login(with credentials: LoginCredentials,
               fetchCompletion: @escaping ((Result<SessionDecoder>) -> Void),
               saveCompletion: @escaping ((Result<Void>) -> Void))
}

class LoginContentProvider: LoginContentProviderType {
    private let apiClient: ApiClientSessionType
    private let coreDataStack: CoreDataStackUserType
    private let accessService: AccessServiceUserIDType
    
    // MARK: - Initialization
    init(apiClient: ApiClientSessionType, coreDataStack: CoreDataStackUserType, accessService: AccessServiceUserIDType) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
        self.accessService = accessService
    }
    
    // MARK: - LoginContentProviderType
    func login(with credentials: LoginCredentials,
               fetchCompletion: @escaping ((Result<SessionDecoder>) -> Void),
               saveCompletion: @escaping ((Result<Void>) -> Void)) {
        apiClient.signIn(with: credentials) { [weak self] result in
            switch result {
            case .success(let userDecoder):
                fetchCompletion(.success(userDecoder))
                self?.save(userDecoder: userDecoder, completion: saveCompletion)
            case .failure(let error):
                fetchCompletion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    private func save(userDecoder: SessionDecoder, completion: @escaping ((Result<Void>) -> Void)) {
        coreDataStack.save(userDecoder: userDecoder, coreDataTypeTranslation: { (transaction: AsynchronousDataTransactionType) -> UserEntity in
            _ = transaction.deleteAll(From<UserEntity>())
            return UserEntity.createUser(from: userDecoder, transaction: transaction)
        }) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.accessService.saveLastLoggedInUserIdentifier(entity.identifier)
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
