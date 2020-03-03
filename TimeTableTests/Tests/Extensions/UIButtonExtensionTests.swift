//
//  UIButtonExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIButtonExtensionTests: XCTestCase {}

// MARK: - localizedStringKey: String?
extension UIButtonExtensionTests {
    func testIfLocalizedStringIsSetProperly() {
        //Arrange
        let sut = UIButton()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "").localizedUppercase
        //Act
        sut.localizedStringKey = string
        //Assert
        XCTAssertEqual(sut.titleLabel?.text, localizedString)
    }
    
    func testIfLocalizedStringReturnsTitleOfTheButton() {
        //Arrange
        let sut = UIButton()
        let string = "key"
        let localizedString = NSLocalizedString(string, comment: "").localizedUppercase
        //Act
        sut.localizedStringKey = string
        //Assert
        XCTAssertEqual(sut.localizedStringKey, localizedString)
    }
}
