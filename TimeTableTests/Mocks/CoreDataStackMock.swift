//
//  CoreDataStackMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreData
@testable import TimeTable

class CoreDataStackMock: CoreDataStackType {
    func save<CDT>(userDecoder: SessionDecoder,
                   coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                   completion: @escaping (Result<CDT>) -> Void) where CDT: NSManagedObject {}
    func fetchUser(forIdentifier identifier: Int, completion: @escaping (Result<UserEntity>) -> Void) {}
}
