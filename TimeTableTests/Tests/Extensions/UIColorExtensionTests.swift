//
//  UIColorExtensionTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UIColorExtensionTests: XCTestCase {}

// MARK: - init(hexString: String, alpha: CGFloat)
extension UIColorExtensionTests {
    func testInitFromHexString() {
        //Arrange
        let rgb: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (231, 20, 40, 1)
        //Act
        let sut = UIColor(hexString: "E71428")
        //Assert
        XCTAssertEqual(sut, UIColor(red: rgb.r/255.0, green: rgb.g/255.0, blue: rgb.b/255.0, alpha: rgb.a))
    }
    
    func testInitFromHexString_withHashSign() {
        //Arrange
        let rgb: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (231, 20, 40, 1)
        //Act
        let sut = UIColor(hexString: "#E71428")
        //Assert
        XCTAssertEqual(sut, UIColor(red: rgb.r/255.0, green: rgb.g/255.0, blue: rgb.b/255.0, alpha: rgb.a))
    }
    
    func testInitFromHexString_withTrailingWhiteSpaces() {
        //Arrange
        let rgb: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (231, 20, 40, 1)
        //Act
        let sut = UIColor(hexString: "E71428     ")
        //Assert
        XCTAssertEqual(sut, UIColor(red: rgb.r/255.0, green: rgb.g/255.0, blue: rgb.b/255.0, alpha: rgb.a))
    }
    
    func testInitFromHexString_withThreeCharacterHex() {
        //Act
        let sut = UIColor(hexString: "EA6")
        //Assert
        XCTAssertNil(sut)
    }
}
