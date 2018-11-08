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
    func fetchUser(forIdentifier identifier: Int, completion: @escaping (Result<UserEntity>) -> Void)
    func save(userDecoder: SessionDecoder, completion: @escaping (Result<Void>) -> Void)
}

class CoreDataStack {
    private static let xcodeModelName = "TimeTable"
    private static let fileName = "TimeTable.sqlite"
    private let stack: DataStackType
    
    enum Error: Swift.Error {
        case storageItemNotFound
    }
    
    // MARK: - Initialization
    init(buildStack: ((_ xcodeModelName: String, _ fileName: String) throws -> DataStackType)) throws {
        self.stack = try buildStack(CoreDataStack.xcodeModelName, CoreDataStack.fileName)
    }
}

// MARK: - CoreDataStackUserType
extension CoreDataStack: CoreDataStackUserType {
    func fetchUser(forIdentifier identifier: Int, completion: @escaping (Result<UserEntity>) -> Void) {
        guard let user = stack.fetchAll(
            From<UserEntity>(),
            Where<UserEntity>("%K == %d", "identifier", identifier)
        )?.first else {
            completion(.failure(Error.storageItemNotFound))
            return
        }
        completion(.success(user))
    }
    
    func save(userDecoder: SessionDecoder, completion: @escaping (Result<Void>) -> Void) {
        stack.perform(asynchronous: { transaction in
            
            transaction.deleteAll(From<UserEntity>())
            
            let user = transaction.create(Into<UserEntity>())
            user.firstName = userDecoder.firstName
            user.lastName = userDecoder.lastName
            user.token = userDecoder.token
            user.identifier = Int64(userDecoder.identifier)
            
        }, success: { result in
            print(result)
            completion(.success(Void()))
        }) { error in
            completion(.failure(error))
        }
    }
}
