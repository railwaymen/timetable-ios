//
//  XCTestCase+Extension.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

extension XCTestCase {
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        return decoder
    }
    
    var exampleURL: URL {
        return URL(string: "www.example.com")!
    }
    
    // MARK: - Functions
    func json<T>(from element: T, file: StaticString = #file, line: UInt = #line) throws -> Data where T: JSONFileResource {
        guard let url = Bundle(for: type(of: self)).url(forResource: element.fileName, withExtension: "json") else {
            let error = "Missing json \(element)"
            XCTFail(error, file: file, line: line)
            throw error
        }
        return try Data(contentsOf: url)
    }
    
    func buildDate(
        timeZone: TimeZone = .current,
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        milisecond: Int = 0
    ) throws -> Date {
        let components = DateComponents(
            calendar: Calendar(identifier: .iso8601),
            timeZone: timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: milisecond * 1_000_000)
        return try XCTUnwrap(components.date)
    }
    
    func buildDate(_ components: DateComponents) throws -> Date {
        return try XCTUnwrap(Calendar(identifier: .iso8601).date(from: components))
    }
}
