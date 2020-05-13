//
//  NewVacationValidationErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationValidationErrorTests: XCTestCase {}

// MARK: - Decodable
extension NewVacationValidationErrorTests {
    func testDecoding_allErrorsEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorEmpty)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
        XCTAssert(sut.description.isEmpty)
        XCTAssert(sut.startDate.isEmpty)
        XCTAssert(sut.endDate.isEmpty)
        XCTAssert(sut.vacationType.isEmpty)
    }
    
    func testDecoding_baseNotEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorBase)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.base.count, 1)
        XCTAssert(sut.base.contains(.workTimeExists))
        XCTAssert(sut.description.isEmpty)
        XCTAssert(sut.startDate.isEmpty)
        XCTAssert(sut.endDate.isEmpty)
        XCTAssert(sut.vacationType.isEmpty)
    }
    
    func testDecoding_desciptionEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorDescriptionBlank)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
        XCTAssertEqual(sut.description.count, 1)
        XCTAssert(sut.description.contains(.blank))
        XCTAssert(sut.startDate.isEmpty)
        XCTAssert(sut.endDate.isEmpty)
        XCTAssert(sut.vacationType.isEmpty)
    }
    
    func testDecoding_startDateBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorStartDateBlank)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
        XCTAssert(sut.description.isEmpty)
        XCTAssertEqual(sut.startDate.count, 1)
        XCTAssert(sut.startDate.contains(.blank))
        XCTAssert(sut.endDate.isEmpty)
        XCTAssert(sut.vacationType.isEmpty)
    }
    
    func testDecoding_startDateGreaterThanEndDate() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorStartDateGreaterThanEndDate)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
        XCTAssert(sut.description.isEmpty)
        XCTAssertEqual(sut.startDate.count, 1)
        XCTAssert(sut.startDate.contains(.greaterThanEndDate))
        XCTAssert(sut.endDate.isEmpty)
        XCTAssert(sut.vacationType.isEmpty)
    }
    
    func testDecoding_endDateBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorEndDateBlank)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
        XCTAssert(sut.description.isEmpty)
        XCTAssert(sut.startDate.isEmpty)
        XCTAssertEqual(sut.endDate.count, 1)
        XCTAssert(sut.endDate.contains(.blank))
        XCTAssert(sut.vacationType.isEmpty)
    }
    
    func testDecoding_vacationTypeBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorVacationTypeBlank)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
        XCTAssert(sut.description.isEmpty)
        XCTAssert(sut.startDate.isEmpty)
        XCTAssert(sut.endDate.isEmpty)
        XCTAssertEqual(sut.vacationType.count, 1)
        XCTAssert(sut.vacationType.contains(.blank))
    }
    
    func testDecoding_vacationTypeInclusion() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorVacationTypeInclusion)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.base.isEmpty)
        XCTAssert(sut.description.isEmpty)
        XCTAssert(sut.startDate.isEmpty)
        XCTAssert(sut.endDate.isEmpty)
        XCTAssertEqual(sut.vacationType.count, 1)
        XCTAssert(sut.vacationType.contains(.inclusion))
    }
    
    func testDecoding_fullModel() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorFullModel)
        //Act
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.base.count, 1)
        XCTAssert(sut.base.contains(.workTimeExists))
        XCTAssertEqual(sut.description.count, 1)
        XCTAssert(sut.description.contains(.blank))
        XCTAssertEqual(sut.startDate.count, 2)
        XCTAssert(sut.startDate.contains(.greaterThanEndDate))
        XCTAssert(sut.startDate.contains(.blank))
        XCTAssertEqual(sut.endDate.count, 1)
        XCTAssert(sut.endDate.contains(.blank))
        XCTAssertEqual(sut.vacationType.count, 2)
        XCTAssert(sut.vacationType.contains(.blank))
        XCTAssert(sut.vacationType.contains(.inclusion))
    }
}

// MARK: - isEmpty
extension NewVacationValidationErrorTests {
    func testIsEmpty_allErrorsEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorEmpty)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssert(sut.isEmpty)
    }
    
    func testIsEmpty_baseNotEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorBase)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_desciptionEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorDescriptionBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startDateBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorStartDateBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_startDateGreaterThanEndDate() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorStartDateGreaterThanEndDate)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_endDateBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorEndDateBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_vacationTypeBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorVacationTypeBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_vacationTypeInclusion() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorVacationTypeInclusion)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
    
    func testIsEmpty_fullModel() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorFullModel)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertFalse(sut.isEmpty)
    }
}

// MARK: - localizedDescription
extension NewVacationValidationErrorTests {
    func testLocalizedDescription_allErrorsEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorEmpty)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, "")
    }
    
    func testLocalizedDescription_baseNotEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorBase)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.newvacation_base_workTimeExists())
    }
    
    func testLocalizedDescription_desciptionEmpty() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorDescriptionBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Act
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.newvacation_description_blank())
    }
    
    func testLocalizedDescription_startDateBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorStartDateBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.newvacation_startDate_blank())
    }
    
    func testLocalizedDescription_startDateGreaterThanEndDate() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorStartDateGreaterThanEndDate)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.newvacation_startDate_greaterThanEndDate())
    }
    
    func testLocalizedDescription_endDateBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorEndDateBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.newvacation_endDate_blank())
    }
    
    func testLocalizedDescription_vacationTypeBlank() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorVacationTypeBlank)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.newvacation_vacationType_blank())
    }
    
    func testLocalizedDescription_vacationTypeInclusion() throws {
        //Arrange
        let data = try self.json(from: NewVacationValidationErrorResponse.newVacationValidationErrorVacationTypeInclusion)
        let sut = try self.decoder.decode(NewVacationValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.newvacation_vacationType_inclusion())
    }
}
