//
//  UITextFieldExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UITextFieldExtensionTests: XCTestCase {
    
    func testIfLocalizedStringIsSetProperly() {
        //Arrange
        let textField = UITextField()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        textField.localizedStringKey = string
        //Assert
        XCTAssertEqual(textField.placeholder, localizedString)
    }
    
    func testIfLocalizedStringReturnsPlaceholderTextOfTheTextField() {
        //Arrange
        let textField = UITextField()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        textField.localizedStringKey = string
        //Assert
        XCTAssertEqual(textField.localizedStringKey, localizedString)
    }
}
