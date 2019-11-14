//
//  UILabelExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIViewExtensionTests: XCTestCase {
    
    func testIfLocalizedStringIsSetProperly() {
        //Arrange
        let label = UILabel()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        label.localizedStringKey = string
        //Assert
        XCTAssertEqual(label.text, localizedString)
    }
    
    func testIfLocalizedStringReturnsTextOfTheLabel() {
        //Arrange
        let label = UILabel()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        label.localizedStringKey = string
        //Assert
        XCTAssertEqual(label.localizedStringKey, localizedString)
    }
}
