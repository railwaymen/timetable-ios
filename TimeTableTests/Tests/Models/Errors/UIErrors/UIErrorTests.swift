//
//  UIErrorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIErrorTests: XCTestCase {}

// MARK: - localizedDescription
extension UIErrorTests {
    func testLocalizedDescription_cannotBeEmpty() {
        //Arrange
        let sut: UIError = .cannotBeEmpty(.projectTextField)
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.error_cannot_be_empty())
    }
    
    func testLocalizedDescription_invalidFormat() {
        //Arrange
        let sut: UIError = .invalidFormat(.projectTextField)
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.error_invalid_format())
    }
    
    func testLocalizedDescription_workTimeGreaterThan() {
        //Arrange
        let sut: UIError = .workTimeGreaterThan
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.worktimeform_error_greater_than())
    }
    
    func testLocalizedDescription_genericError() {
        //Arrange
        let sut: UIError = .genericError
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.error_something_went_wrong())
    }
    
    func testLocalizedDescription_remoteWorkStartsAtIncorrectHours() {
        //Arrange
        let sut: UIError = .remoteWorkStartsAtIncorrectHours
        //Act
        let localizedDescription = sut.localizedDescription
        //Assert
        XCTAssertEqual(localizedDescription, R.string.localizable.registerremotework_error_startsAt_incorrectHours())
    }
}
