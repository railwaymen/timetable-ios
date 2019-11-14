//
//  UIColorExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIColorExtensionTests: XCTestCase {
    
    func testConvenienceInitFromHexString() {
        //Arrange
        let rgb: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (231, 20, 40, 1)
        //Act
        let color = UIColor(hexString: "E71428")
        //Assert
        XCTAssertEqual(color, UIColor(red: rgb.r/255.0, green: rgb.g/255.0, blue: rgb.b/255.0, alpha: rgb.a))
    }
    
    func testConvenienceInitFromHexStringWithHashSign() {
        //Arrange
        let rgb: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (231, 20, 40, 1)
        //Act
        let color = UIColor(hexString: "#E71428")
        //Assert
        XCTAssertEqual(color, UIColor(red: rgb.r/255.0, green: rgb.g/255.0, blue: rgb.b/255.0, alpha: rgb.a))
    }
}
