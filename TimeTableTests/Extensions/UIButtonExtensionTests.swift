//
//  UIButtonExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIButtonExtensionTests: XCTestCase {
    
    func testIfLocalizedStringIsSetProperly() {
        //Arrange
        let button = UIButton()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        button.localizedStringKey = string
        //Assert
        XCTAssertEqual(button.titleLabel?.text, localizedString)
    }
    
    func testIfLocalizedStringReturnsTitleOfTheButton() {
        //Arrange
        let button = UIButton()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "")
        //Act
        button.localizedStringKey = string
        //Assert
        XCTAssertEqual(button.localizedStringKey, localizedString)
    }
}
