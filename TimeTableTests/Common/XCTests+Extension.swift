//
//  XCTests+Extension.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import CoreData
@testable import TimeTable

extension XCTestCase {
    func createInMemoryStorage() throws -> NSManagedObjectContext {
        let model = try NSManagedObjectModel.mergedModel(from: nil).unwrap()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {}
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        return context
    }
}
