//
//  DataStackMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore
@testable import TimeTable

class DataStackMock: DataStackType {
    
    var user: UserEntity?
    func fetchAll<D>(_ from: From<D>, _ fetchClauses: FetchClause...) throws -> [D] {
        guard let returnType = [user] as? [D] else {
            throw TestError(message: "Cast failed")
        }
        return returnType
    }
    
    private(set) var performFailure: ((CoreStoreError) -> Void)?
    private(set) var performSuccess: ((UserEntity) -> Void)?
    private(set) var performTask: ((AsynchronousDataTransactionType) throws -> UserEntity)?
    
    func perform<T>(asynchronousTask: @escaping (_ transaction: AsynchronousDataTransactionType) throws -> T,
                    success: @escaping (T) -> Void, failure: @escaping (CoreStoreError) -> Void) {
        // swiftlint:disable force_cast
        performFailure = failure
        performSuccess = { value in
            success(value as! T)
        }
        performTask = { transaction in
            return try asynchronousTask(transaction) as! UserEntity
        }
        // swiftlint:enable force_cast
    }
}
