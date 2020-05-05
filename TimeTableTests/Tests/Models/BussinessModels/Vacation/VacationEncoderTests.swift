//
//  VacationEncoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 29/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class VacationEncoderTests: XCTestCase {}

// MARK: - Encodable
extension VacationEncoderTests {
    func testEncoding_plannedVacationType() throws {
        //Arrange
        let sut = try self.buildSut(type: .planned, note: "description")
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let params = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any])
        XCTAssertEqual(params.count, 4)
        XCTAssertEqual(params["vacation_type"] as? String, "planned")
        XCTAssertEqual(params["description"] as? String, "description")
        XCTAssertEqual(params["start_date"] as? String, "2020-04-29")
        XCTAssertEqual(params["end_date"] as? String, "2020-04-30")
    }
    
    func testEncoding_requestedVacationType() throws {
        //Arrange
        let sut = try self.buildSut(type: .requested, note: "description")
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let params = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any])
        XCTAssertEqual(params.count, 4)
        XCTAssertEqual(params["vacation_type"] as? String, "requested")
        XCTAssertEqual(params["description"] as? String, "description")
        XCTAssertEqual(params["start_date"] as? String, "2020-04-29")
        XCTAssertEqual(params["end_date"] as? String, "2020-04-30")
    }
    
    func testEncoding_compassionateVacationType() throws {
        //Arrange
        let sut = try self.buildSut(type: .compassionate, note: "description")
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let params = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any])
        XCTAssertEqual(params.count, 4)
        XCTAssertEqual(params["vacation_type"] as? String, "compassionate")
        XCTAssertEqual(params["description"] as? String, "description")
        XCTAssertEqual(params["start_date"] as? String, "2020-04-29")
        XCTAssertEqual(params["end_date"] as? String, "2020-04-30")
    }
    
    func testEncoding_othersVacationType() throws {
        //Arrange
        let sut = try self.buildSut(type: .others, note: "description")
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let params = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any])
        XCTAssertEqual(params.count, 4)
        XCTAssertEqual(params["vacation_type"] as? String, "others")
        XCTAssertEqual(params["description"] as? String, "description")
        XCTAssertEqual(params["start_date"] as? String, "2020-04-29")
        XCTAssertEqual(params["end_date"] as? String, "2020-04-30")
    }
    
    func testEncoding_desciptionNotNull() throws {
        //Arrange
        let sut = try self.buildSut(type: .others, note: "description not null")
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let params = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any])
        XCTAssertEqual(params.count, 4)
        XCTAssertEqual(params["vacation_type"] as? String, "others")
        XCTAssertEqual(params["description"] as? String, "description not null")
        XCTAssertEqual(params["start_date"] as? String, "2020-04-29")
        XCTAssertEqual(params["end_date"] as? String, "2020-04-30")
    }
    
    func testEncoding_desciptionNull() throws {
        //Arrange
        let sut = try self.buildSut(type: .others, note: nil)
        //Act
        let data = try self.encoder.encode(sut)
        //Assert
        let params = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any])
        XCTAssertEqual(params.count, 4)
        XCTAssertEqual(params["vacation_type"] as? String, "others")
        XCTAssert(params["description"] is NSNull)
        XCTAssertEqual(params["start_date"] as? String, "2020-04-29")
        XCTAssertEqual(params["end_date"] as? String, "2020-04-30")
    }
}

extension VacationEncoderTests {
    private func buildSut(type: VacationType, note: String?) throws -> VacationEncoder {
        return VacationEncoder(
            type: type,
            note: note,
            startDate: try self.buildDate(year: 2020, month: 04, day: 29),
            endDate: try self.buildDate(year: 2020, month: 04, day: 30))
    }
}
