//
//  UITextFieldExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UITextFieldExtensionTests: XCTestCase {}

// MARK: - localizedStringKey: String?
extension UITextFieldExtensionTests {
    func testIfLocalizedStringIsSetProperly() {
        //Arrange
        let sut = UITextField()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        sut.localizedStringKey = string
        //Assert
        XCTAssertEqual(sut.placeholder, localizedString)
    }
    
    func testIfLocalizedStringReturnsPlaceholderTextOfTheTextField() {
        //Arrange
        let sut = UITextField()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        sut.localizedStringKey = string
        //Assert
        XCTAssertEqual(sut.localizedStringKey, localizedString)
    }
}
