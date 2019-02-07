//
//  MatchingFullTimeDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class MatchingFullTimeDecoderTests: XCTestCase {
    
    private enum MatchingFullTimeResponse: String, JSONFileResource {
        case matchingFullTimeFullResponse
        case matchingFullTimeNullPeriod
        case matchingFullTimeMissingPeriodKey
        case matchingFullTimeNullShouldWorked
        case matchingFullTimeMissingShouldWorkedKey
    }
    
    private lazy var decoder = JSONDecoder()
 
    func testParsingMatchingFullTimeFullResponse() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeResponse.matchingFullTimeFullResponse)
        //Act
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(matchingFullTime.period?.identifier, 1383)
        XCTAssertEqual(matchingFullTime.period?.countedDuration, TimeInterval(620100))
        XCTAssertEqual(matchingFullTime.period?.duration, TimeInterval(633600))
        XCTAssertEqual(matchingFullTime.shouldWorked, TimeInterval(633600))
    }
    
    func testMatchingFullTimeNullPeriod() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeResponse.matchingFullTimeNullPeriod)
        //Act
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertNil(matchingFullTime.period)
        XCTAssertEqual(matchingFullTime.shouldWorked, TimeInterval(633600))
    }
    
    func testMatchingFullTimeMissingPeriodKey() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeResponse.matchingFullTimeMissingPeriodKey)
        //Act
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertNil(matchingFullTime.period)
        XCTAssertEqual(matchingFullTime.shouldWorked, TimeInterval(633600))
    }

    func testMatchingFullTimeNullShouldWorked() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeResponse.matchingFullTimeNullShouldWorked)
        //Act
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(matchingFullTime.period?.identifier, 1383)
        XCTAssertEqual(matchingFullTime.period?.countedDuration, TimeInterval(620100))
        XCTAssertEqual(matchingFullTime.period?.duration, TimeInterval(633600))
        XCTAssertNil(matchingFullTime.shouldWorked)
    }
    
    func testMatchingFullTimeMissingShouldWorkedKey() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeResponse.matchingFullTimeMissingShouldWorkedKey)
        //Act
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(matchingFullTime.period?.identifier, 1383)
        XCTAssertEqual(matchingFullTime.period?.countedDuration, TimeInterval(620100))
        XCTAssertEqual(matchingFullTime.period?.duration, TimeInterval(633600))
        XCTAssertNil(matchingFullTime.shouldWorked)
    }
}
