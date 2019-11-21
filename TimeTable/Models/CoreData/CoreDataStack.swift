//
//  CoreDataStack.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore

typealias CoreDataStackType = (CoreDataStackUserType)

protocol CoreDataStackUserType: class {
    func deleteUser(forIdentifier identifier: Int64, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchUser(forIdentifier identifier: Int64, completion: @escaping (Result<UserEntity, Error>) -> Void)
    func fetchAllUsers(completion: @escaping (Result<[UserEntity], Error>) -> Void)
    func save<CDT: NSManagedObject>(userDecoder: SessionDecoder,
                                    coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                                    completion: @escaping (Result<CDT, Error>) -> Void)
}

class CoreDataStack {
    private static let xcodeModelName = "TimeTable"
    private static let fileName = "TimeTable.sqlite"
    
    private let stack: DataStackType
    
    // MARK: - Initialization
    init(buildStack: ((_ xcodeModelName: String, _ fileName: String) throws -> DataStackType)) throws {
        self.stack = try buildStack(CoreDataStack.xcodeModelName, CoreDataStack.fileName)
    }
}

// MARK: - Structures
extension CoreDataStack {
    enum Error: Swift.Error {
        case storageItemNotFound
    }
}

// MARK: - CoreDataStackUserType
extension CoreDataStack: CoreDataStackUserType {
    func deleteUser(forIdentifier identifier: Int64, completion: @escaping (Result<Void, Swift.Error>) -> Void) {
        self.fetchUser(forIdentifier: identifier) { [unowned self] result in
            switch result {
            case .success(let user):
                self.stack.perform(asynchronousTask: { (transaction) -> Void in
                    transaction.delete(user)
                }, success: { _ in
                    completion(.success(Void()))
                }, failure: { error in
                    completion(.failure(error))
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUser(forIdentifier identifier: Int64, completion: @escaping (Result<UserEntity, Swift.Error>) -> Void) {
        guard let user = (try? self.stack.fetchAll(
            From<UserEntity>(),
            Where<UserEntity>("%K == %d", "identifier", identifier)
        ))?.first else {
            completion(.failure(Error.storageItemNotFound))
            return
        }
        completion(.success(user))
    }
    
    func fetchAllUsers(completion: @escaping (Result<[UserEntity], Swift.Error>) -> Void) {
        do {
            let users = try self.stack.fetchAll(From<UserEntity>())
            completion(.success(users))
        } catch {
            return completion(.failure(error))
        }
    }
    
    func save<CDT: NSManagedObject>(userDecoder: SessionDecoder,
                                    coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                                    completion: @escaping (Result<CDT, Swift.Error>) -> Void) {
        self.stack.perform(asynchronousTask: { transaction in
            return coreDataTypeTranslation(transaction)
        }, success: { entity in
            completion(.success(entity))
        }) { error in
            completion(.failure(error))
        }
    }
}
