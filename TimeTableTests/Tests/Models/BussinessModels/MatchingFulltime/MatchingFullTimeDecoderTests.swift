//
//  MatchingFullTimeDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class MatchingFullTimeDecoderTests: XCTestCase {}

// MARK: - Decodable
extension MatchingFullTimeDecoderTests {
    func testDecoding_matchingFullTimeFullResponse() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeFullResponse)
        //Act
        let sut = try self.decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.accountingPeriod?.identifier, 1383)
        XCTAssertEqual(sut.accountingPeriod?.countedDuration, TimeInterval(620100))
        XCTAssertEqual(sut.accountingPeriod?.duration, TimeInterval(633600))
        XCTAssertEqual(sut.shouldWorked, TimeInterval(633600))
    }
    
    func testDecoding_matchingFullTimeNullPeriod() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeNullPeriod)
        //Act
        let sut = try self.decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut.accountingPeriod)
        XCTAssertEqual(sut.shouldWorked, TimeInterval(633600))
    }
    
    func testDecoding_matchingFullTimeMissingPeriodKey() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeMissingPeriodKey)
        //Act
        let sut = try self.decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertNil(sut.accountingPeriod)
        XCTAssertEqual(sut.shouldWorked, TimeInterval(633600))
    }

    func testDecoding_matchingFullTimeNullShouldWorked() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeNullShouldWorked)
        //Act
        let sut = try self.decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.accountingPeriod?.identifier, 1383)
        XCTAssertEqual(sut.accountingPeriod?.countedDuration, TimeInterval(620100))
        XCTAssertEqual(sut.accountingPeriod?.duration, TimeInterval(633600))
        XCTAssertNil(sut.shouldWorked)
    }
    
    func testDecoding_matchingFullTimeMissingShouldWorkedKey() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeMissingShouldWorkedKey)
        //Act
        let sut = try self.decoder.decode(MatchingFullTimeDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.accountingPeriod?.identifier, 1383)
        XCTAssertEqual(sut.accountingPeriod?.countedDuration, TimeInterval(620100))
        XCTAssertEqual(sut.accountingPeriod?.duration, TimeInterval(633600))
        XCTAssertNil(sut.shouldWorked)
    }
}
