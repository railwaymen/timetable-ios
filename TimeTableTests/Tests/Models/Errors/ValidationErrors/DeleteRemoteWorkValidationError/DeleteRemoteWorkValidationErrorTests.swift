//
//  DeleteRemoteWorkValidationErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

import XCTest
@testable import TimeTable

class DeleteRemoteWorkValidationErrorTests: XCTestCase {}

// MARK: - Decodable
extension DeleteRemoteWorkValidationErrorTests {
    func testDecoding_allErrorsEmpty() throws {
        //Arrange
        let data = try self.json(from: DeleteRemoteWorkValidationErrorResponse.deleteRemoteWorkValidationErrorEmpty)
        //Act
        let sut = try self.decoder.decode(DeleteRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssert(sut.startsAt.isEmpty)
    }
    
    func testDecoding_startsAtTooOld() throws {
        //Arrange
        let data = try self.json(from: DeleteRemoteWorkValidationErrorResponse.deleteRemoteWorkValidationStartsAtTooOld)
        //Act
        let sut = try self.decoder.decode(DeleteRemoteWorkValidationError.self, from: data)
        //Assert
        XCTAssertEqual(sut.startsAt.count, 1)
        XCTAssert(sut.startsAt.contains(.tooOld))
    }
}

// MARK: - localizedDescription
extension DeleteRemoteWorkValidationErrorTests {
    func testLocalizedDescription_allErrorsEmpty() throws {
        //Arrange
        let sut = try self.buildSUT(type: .deleteRemoteWorkValidationErrorEmpty)
        //Assert
        XCTAssertEqual(sut.localizedDescription, "")
    }
    
    func testLocalizedDescription_startsAtTooOld() throws {
        //Arrange
        let sut = try self.buildSUT(type: .deleteRemoteWorkValidationStartsAtTooOld)
        //Assert
        XCTAssertEqual(sut.localizedDescription, R.string.localizable.deleteremotework_error_startsAt_tooOld())
    }
}

// MARK: - Private
extension DeleteRemoteWorkValidationErrorTests {
    private func buildSUT(type: DeleteRemoteWorkValidationErrorResponse) throws -> DeleteRemoteWorkValidationError {
        let data = try self.json(from: type)
        return try self.decoder.decode(DeleteRemoteWorkValidationError.self, from: data)
    }
}
