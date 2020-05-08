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

// MARK: - func convertToEncoder() -> RemoteWorkRequest
extension RemoteWorkFormTests {
    func testConverToEncoder() {
        //Arrange
        let sut = RemoteWorkForm()
        //Act
        let encoder = sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startsAt == sut.startsAt)
        XCTAssert(encoder.endsAt == sut.endsAt)
        XCTAssert(encoder.note == sut.note)
    }
}
