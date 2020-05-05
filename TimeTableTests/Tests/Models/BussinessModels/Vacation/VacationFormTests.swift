//
//  VacationFormTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class VacationFormTests: XCTestCase {}

// MARK: - func validationErrors() -> [VacationForm.ValidationError]
extension VacationFormTests {
    func testValidationErros_typePlanned_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .planned)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typePlanned_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .planned, note: "note")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeRequested_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .requested)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeRequested_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .requested, note: "note")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeCompassionate_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .compassionate)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeCompassionate_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .compassionate, note: "note")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeOthers_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .others)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(!errors.isEmpty)
        XCTAssert(errors.contains(.cannotBeEmpty(.noteTextView)))
    }
    
    func testValidationErros_typeOthers_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .others, note: "note")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
}

// MARK: - func convertToEncoder() throws -> VacationEncoder
extension VacationFormTests {
    func testConvertToEncoder_typePlanned_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .planned)
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typePlanned_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .planned, note: "note")
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typeRequested_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .requested)
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typeRequested_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .requested, note: "note")
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typeCompassionate_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .compassionate)
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typeCompassionate_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .compassionate, note: "note")
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typeOthers_emptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .others)
        //Act
        XCTAssertThrowsError(try sut.convertToEncoder()) { error in
            //Assert
            XCTAssertEqual(error as? UIError, UIError.cannotBeEmpty(.noteTextView))
        }
    }
    
    func testConvertToEncoder_typeOthers_notEmptyNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .others, note: "note")
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
}

// MARK: - Private
extension VacationFormTests {
    private func buildSUT(type: VacationType, note: String = "") throws -> VacationForm {
        VacationForm(
            type: type,
            note: note)
    }
}
