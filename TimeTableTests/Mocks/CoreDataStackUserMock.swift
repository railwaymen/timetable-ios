//
//  CoreDataStackUserMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class CoreDataStackUserMock: CoreDataStackUserType {
    
    typealias CDT = UserEntity
    var fetchUserexpectationHandler: (() -> Void)?
    private(set) var fetchUserIdentifier: Int64?
    private(set) var fetchUserCompletion: ((Result<UserEntity>) -> Void)?
    private(set) var saveUserDecoder: SessionDecoder?
    private(set) var saveUserCompletion: ((Result<UserEntity>) -> Void)?
    private(set) var saveCoreDataTypeTranslatior: ((AsynchronousDataTransactionType) -> UserEntity)?
    
    func fetchUser(forIdentifier identifier: Int64, completion: @escaping (Result<UserEntity>) -> Void) {
        fetchUserIdentifier = identifier
        fetchUserCompletion = completion
        fetchUserexpectationHandler?()
    }
    
    func save<CDT>(userDecoder: SessionDecoder,
                   coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                   completion: @escaping (Result<CDT>) -> Void) {
        
        // swiftlint:disable force_cast
        saveUserDecoder = userDecoder
        saveUserCompletion = { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let entity):
                completion(.success(entity as! CDT))
            }
        }
        saveCoreDataTypeTranslatior = { transaction in
            return coreDataTypeTranslation(transaction) as! UserEntity
        }
        // swiftlint:enable force_cast
    }
}
