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
               fetchCompletion: @escaping ((Result<SessionDecoder, Error>) -> Void),
               saveCompletion: @escaping ((Result<Void, Error>) -> Void))
}

class LoginContentProvider {
    private let apiClient: ApiClientSessionType
    private let coreDataStack: CoreDataStackUserType
    private let accessService: AccessServiceUserIDType
    
    // MARK: - Initialization
    init(
        apiClient: ApiClientSessionType,
        coreDataStack: CoreDataStackUserType,
        accessService: AccessServiceUserIDType
    ) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
        self.accessService = accessService
    }
}
    
// MARK: - LoginContentProviderType
extension LoginContentProvider: LoginContentProviderType {
    func login(
        with credentials: LoginCredentials,
        fetchCompletion: @escaping ((Result<SessionDecoder, Error>) -> Void),
        saveCompletion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        self.apiClient.signIn(with: credentials) { [weak self] result in
            switch result {
            case .success(let userDecoder):
                fetchCompletion(.success(userDecoder))
                self?.save(userDecoder: userDecoder, completion: saveCompletion)
            case .failure(let error):
                fetchCompletion(.failure(error))
            }
        }
    }
    
}

// MARK: - Private
extension LoginContentProvider {
    private func save(userDecoder: SessionDecoder, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.coreDataStack.fetchAllUsers { [weak self] result in
            switch result {
            case let .success(users):
                self?.handleSaveSuccess(users: users, userDecoder: userDecoder, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleSaveSuccess(users: [UserEntity], userDecoder: SessionDecoder, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.coreDataStack.save(
            userDecoder: userDecoder,
            coreDataTypeTranslation: { (transaction: AsynchronousDataTransactionType) -> UserEntity in
                transaction.delete(users)
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
