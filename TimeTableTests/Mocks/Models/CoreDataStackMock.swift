//
//  CoreDataStackMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class CoreDataStackMock {
    typealias CDT = UserEntity
    
    private(set) var deleteUserParams: [DeleteUserParams] = []
    struct DeleteUserParams {
        var identifier: Int64
        var completion: (Result<Void, Error>) -> Void
    }
    
    private(set) var fetchUserParams: [FetchUserParams] = []
    struct FetchUserParams {
        var identifier: Int64
        var completion: (Result<UserEntity, Error>) -> Void
    }
    
    private(set) var fetchAllUsersParams: [FetchAllUsersParams] = []
    struct FetchAllUsersParams {
        var completion: (Result<[UserEntity], Error>) -> Void
    }
    
    private(set) var saveParams: [SaveParams] = []
    struct SaveParams {
        var userDecoder: SessionDecoder
        var translation: (AsynchronousDataTransactionType) -> UserEntity
        var completion: (Result<UserEntity, Error>) -> Void
    }
}

// MARK: - CoreDataStackType
extension CoreDataStackMock: CoreDataStackType {
    func deleteUser(forIdentifier identifier: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        self.deleteUserParams.append(DeleteUserParams(identifier: identifier, completion: completion))
    }
    
    func fetchUser(forIdentifier identifier: Int64, completion: @escaping (Result<UserEntity, Error>) -> Void) {
        self.fetchUserParams.append(FetchUserParams(identifier: identifier, completion: completion))
    }
    
    func fetchAllUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        self.fetchAllUsersParams.append(FetchAllUsersParams(completion: completion))
    }
    
    func save<CDT>(userDecoder: SessionDecoder,
                   coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                   completion: @escaping (Result<CDT, Error>) -> Void) {
        // swiftlint:disable force_cast
        let completion: (Result<UserEntity, Error>) -> Void = { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let entity):
                completion(.success(entity as! CDT))
            }
        }
        let translation: (AsynchronousDataTransactionType) -> UserEntity = { transaction in
            return coreDataTypeTranslation(transaction) as! UserEntity
        }
        // swiftlint:enable force_cast
        self.saveParams.append(SaveParams(userDecoder: userDecoder, translation: translation, completion: completion))
    }
}
