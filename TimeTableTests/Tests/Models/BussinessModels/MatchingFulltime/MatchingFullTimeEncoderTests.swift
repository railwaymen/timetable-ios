//
//  MatchingFullTimeEncoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class MatchingFullTimeEncoderTests: XCTestCase {}

// MARK: - Encodable
extension MatchingFullTimeEncoderTests {
    func testEncoding_fullModel() throws {
        //Arrange
        let date = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let sut = MatchingFullTimeEncoder(date: date, userId: 1)
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        let dateString = try XCTUnwrap(requestDictionary?["date"] as? String)
        let userId = try XCTUnwrap(requestDictionary?["user_id"] as? Int)
        XCTAssertEqual(dateString, "2018-01-17")
        XCTAssertEqual(userId, 1)
    }
    
    func testEncoding_nilDate() throws {
        //Arrange
        let sut = MatchingFullTimeEncoder(date: nil, userId: 1)
        var thrownError: Error?
        //Act
        do {
            _ = try self.encoder.encode(sut)
        } catch {
            thrownError = error
        }
        //Assert
        XCTAssertTrue(thrownError is EncodingError)
    }
    
    func testEncoding_nilUserId() throws {
        //Arrange
        let date = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let sut = MatchingFullTimeEncoder(date: date, userId: nil)
        var thrownError: Error?
        //Act
        do {
            _ = try self.encoder.encode(sut)
        } catch {
            thrownError = error
        }
        //Assert
        XCTAssertTrue(thrownError is EncodingError)
    }
}
