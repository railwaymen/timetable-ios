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

class DataStackMock {
    
    var fetchAllReturnType: UserEntity!
    private(set) var fetchAllParams: [FetchAllParams] = []
    struct FetchAllParams {}
    
    private(set) var performParams: [PerformParams] = []
    struct PerformParams {
        var asynchronousTask: (AsynchronousDataTransactionType) throws -> UserEntity
        var success: (UserEntity) -> Void
        var failure: (CoreStoreError) -> Void
    }
}

// MARK: - DataStackType
extension DataStackMock: DataStackType {
    func fetchAll<D>(_ from: From<D>, _ fetchClauses: FetchClause...) throws -> [D] where D: DynamicObject {
        self.fetchAllParams.append(FetchAllParams())
        guard let returnValue = [self.fetchAllReturnType] as? [D] else {
            throw TestError(message: "test")
        }
        return returnValue
    }
    
    func perform<T>(asynchronousTask: @escaping (AsynchronousDataTransactionType) throws -> T,
                    success: @escaping (T) -> Void,
                    failure: @escaping (CoreStoreError) -> Void) {
        // swiftlint:disable force_cast
        let newSuccess: (UserEntity) -> Void = { value in
            success(value as! T)
        }
        let newTask: (AsynchronousDataTransactionType) throws -> UserEntity = { transaction in
            return try asynchronousTask(transaction) as! UserEntity
        }
        // swiftlint:enable force_cast
        self.performParams.append(PerformParams(asynchronousTask: newTask, success: newSuccess, failure: failure))
    }
}
