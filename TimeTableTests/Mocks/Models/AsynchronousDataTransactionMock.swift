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
        
    private(set) var deleteParams: [DeleteParams] = []
    struct DeleteParams {}
    
    var createReturnValue: DynamicObject!
    private(set) var createParams: [CreateParams] = []
    struct CreateParams {}
}

// MARK: - AsynchronousDataTransactionType
extension AsynchronousDataTransactionMock: AsynchronousDataTransactionType {
    func delete<S>(_ objects: S) where S: Sequence, S.Element: ObjectRepresentation {
        self.deleteParams.append(DeleteParams())
    }
    
    func delete<O>(_ object: O?, _ objects: O?...) where O: ObjectRepresentation {
        self.deleteParams.append(DeleteParams())
    }
    
    func create<D>(_ into: Into<D>) -> D where D: DynamicObject {
        self.createParams.append(CreateParams())
        // swiftlint:disable force_cast
        return self.createReturnValue as! D
        // swiftlint:enable force_cast
    }
}
