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

class AsynchronousDataTransactionMock: AsynchronousDataTransactionType {
    
    private(set) var deleteAllCalled = false
    private(set) var createCalled = false
    var user: DynamicObject?
    
    func deleteAll<D>(_ from: From<D>, _ deleteClauses: DeleteClause...) -> Int? where D: DynamicObject {
        deleteAllCalled = true
        return nil
    }
    
    func create<D>(_ into: Into<D>) -> D where D: DynamicObject {
        createCalled = true
        // swiftlint:disable force_cast
        return user as! D
        // swiftlint:enable force_cast
    }
}
