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
        let sut = try self.buildSUT()
        //Act
        let encoder = sut.convertToEncoder()
        //Assert
        XCTAssert(encoder.startDate == sut.startDate)
        XCTAssert(encoder.endDate == sut.endDate)
        XCTAssert(encoder.note == sut.note)
    }
}

// MARK: - Private
extension RemoteWorkFormTests {
    private func buildSUT() -> RemoteWorkForm {
        return RemoteWorkRequest(note: "note", startsAt: Date(), endsAt: Date())
    }
}
