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
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }
    
    var exampleURL: URL {
        return URL(string: "www.example.com")!
    }
    
    func createInMemoryStorage() throws -> NSManagedObjectContext {
        let model = try XCTUnwrap(NSManagedObjectModel.mergedModel(from: nil))
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {}
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        return context
    }
    
    func buildDate(timeZone: TimeZone = .current, year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) throws -> Date {
        let components = DateComponents(
            calendar: Calendar(identifier: .iso8601),
            timeZone: timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second)
        return try XCTUnwrap(components.date)
    }
    
    func buildDate(_ components: DateComponents) throws -> Date {
        return try XCTUnwrap(Calendar(identifier: .iso8601).date(from: components))
    }
}
