//
//  MatchingFullTimeEncoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class MatchingFullTimeEncoderTests: XCTestCase {
    private var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    func testCreatedMatchingFullTimeEncoderIsCorrect() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let date = try Calendar.current.date(from: components).unwrap()
        let sut = MatchingFullTimeEncoder(date: date, userIdentifier: 1)
        //Act
        let data = try self.encoder.encode(sut)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        let dateString = try (requestDictionary?["date"] as? String).unwrap()
        let userId = try (requestDictionary?["user_id"] as? Int).unwrap()
        XCTAssertEqual(dateString, "2018-01-17")
        XCTAssertEqual(userId, 1)
    }
    
    func testCreatedMatchingFullTimeEncoderFailsWhileDateIsNil() throws {
        //Arrange
        let sut = MatchingFullTimeEncoder(date: nil, userIdentifier: 1)
        //Act
        do {
            _ = try self.encoder.encode(sut)
        } catch {
            //Assert
            XCTAssertNotNil(error as? EncodingError)
        }
    }
    
    func testCreatedMatchingFullTimeEncoderFailsWhileUserIdentfierIsNil() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let date = try Calendar.current.date(from: components).unwrap()
        let sut = MatchingFullTimeEncoder(date: date, userIdentifier: nil)
        //Act
        do {
            _ = try self.encoder.encode(sut)
        } catch {
            //Assert
            XCTAssertNotNil(error as? EncodingError)
        }
    }
}
