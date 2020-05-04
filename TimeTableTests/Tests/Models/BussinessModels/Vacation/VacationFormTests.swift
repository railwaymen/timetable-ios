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
    func testValidationErros_typePlanned_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .planned, note: nil)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typePlanned_notNullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .planned, note: "note")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeRequested_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .requested, note: nil)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeRequested_notNullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .requested, note: "note")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeCompassionate_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .compassionate, note: nil)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeCompassionate_notNullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .compassionate, note: "note")
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(errors.isEmpty)
    }
    
    func testValidationErros_typeOthers_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .others, note: nil)
        //Act
        let errors = sut.validationErrors()
        //Assert
        XCTAssert(!errors.isEmpty)
        XCTAssert(errors.contains(.noteIsNil))
    }
    
    func testValidationErros_typeOthers_notNullNote() throws {
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
    func testConvertToEncoder_typePlanned_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .planned, note: nil)
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typePlanned_notNullNote() throws {
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
    
    func testConvertToEncoder_typeRequested_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .requested, note: nil)
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typeRequested_notNullNote() throws {
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
    
    func testConvertToEncoder_typeCompassionate_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .compassionate, note: nil)
        //Act
        let encoder = try sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.type == sut.type)
        XCTAssert(encoder.note == sut.note)
    }
    
    func testConvertToEncoder_typeCompassionate_notNullNote() throws {
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
    
    func testConvertToEncoder_typeOthers_nullNote() throws {
        //Arrange
        let sut = try self.buildSUT(type: .others, note: nil)
        //Act
        XCTAssertThrowsError(try sut.convertToEncoder()) { error in
            //Assert
            XCTAssertEqual(error as? VacationForm.ValidationError, VacationForm.ValidationError.noteIsNil)
        }
    }
    
    func testConvertToEncoder_typeOthers_notNullNote() throws {
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

extension VacationFormTests {
    private func buildSUT(type: VacationType, note: String?) throws -> VacationForm {
        VacationForm(
            type: type,
            note: note)
    }
}

