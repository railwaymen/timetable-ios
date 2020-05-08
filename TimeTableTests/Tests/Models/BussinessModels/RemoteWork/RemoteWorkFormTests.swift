//
//  RemoteWorkFormTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RemoteWorkFormTests: XCTestCase {}

// MARK: - func convertToEncoder()
extension RemoteWorkFormTests {
    func testConvertToEncoder() {
        //Arrange
        let sut = RemoteWorkForm()
        //Act
        let encoder = sut.convertToEncoder()
        //Assert
        XCTAssertEqual(encoder.startsAt, sut.startsAt)
        XCTAssertEqual(encoder.endsAt, sut.endsAt)
        XCTAssertEqual(encoder.note, sut.note)
    }
}
