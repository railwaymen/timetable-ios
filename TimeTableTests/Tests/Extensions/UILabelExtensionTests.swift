//
//  UILabelExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UILabelExtensionTests: XCTestCase {}

// MARK: - localizedStringKey: String?
extension UILabelExtensionTests {
    func testIfLocalizedStringIsSetProperly() {
        //Arrange
        let sut = UILabel()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        sut.localizedStringKey = string
        //Assert
        XCTAssertEqual(sut.text, localizedString)
    }
    
    func testIfLocalizedStringReturnsTextOfTheLabel() {
        //Arrange
        let sut = UILabel()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        sut.localizedStringKey = string
        //Assert
        XCTAssertEqual(sut.localizedStringKey, localizedString)
    }
}
