//
//  AsynchronousDataTransactionMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore
@testable import TimeTable

class AsynchronousDataTransactionMock {
    
    var deleteAllReturnValue: Int = 0
    var deleteAllThrowError: Error?
    private(set) var deleteAllParams: [DeleteAllParams] = []
    struct DeleteAllParams {}
    
    private(set) var deleteParams: [DeleteParams] = []
    struct DeleteParams {}
    
    var createReturnValue: DynamicObject!
    private(set) var createParams: [CreateParams] = []
    struct CreateParams {}
}

// MARK: - AsynchronousDataTransactionType
extension AsynchronousDataTransactionMock: AsynchronousDataTransactionType {
    func deleteAll<D>(_ from: From<D>, _ deleteClauses: DeleteClause...) throws -> Int where D: DynamicObject {
        self.deleteAllParams.append(DeleteAllParams())
        if let error = self.deleteAllThrowError {
            throw error
        }
        return self.deleteAllReturnValue
    }
    
    func delete<D>(_ object: D?) where D: DynamicObject {
        self.deleteParams.append(DeleteParams())
    }
    
    func create<D>(_ into: Into<D>) -> D where D: DynamicObject {
        self.createParams.append(CreateParams())
        // swiftlint:disable force_cast
        return self.createReturnValue as! D
        // swiftlint:enable force_cast
    }
}
