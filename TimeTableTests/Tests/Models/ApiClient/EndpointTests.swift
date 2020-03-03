//
//  EndpointTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 03/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class EndpointTests: XCTestCase {}

// MARK: - value: String
extension EndpointTests {
    func testValue_matchingFullTime() {
        //Act
        let value = Endpoint.matchingFullTime.value
        //Assert
        XCTAssertEqual(value, "/accounting_periods/matching_fulltime")
    }
    
    func testValue_projects() {
        //Act
        let value = Endpoint.projects.value
        //Assert
        XCTAssertEqual(value, "/projects")
    }
    
    func testValue_projectsSimpleList() {
        //Act
        let value = Endpoint.projectsSimpleList.value
        //Assert
        XCTAssertEqual(value, "/projects/simple")
    }
    
    func testValue_signIn() {
        //Act
        let value = Endpoint.signIn.value
        //Assert
        XCTAssertEqual(value, "/users/sign_in")
    }
    
    func testValue_workTime() {
        //Act
        let value = Endpoint.workTime(1).value
        //Assert
        XCTAssertEqual(value, "/work_times/1")
    }
    
    func testValue_workTimes() {
        //Act
        let value = Endpoint.workTimes.value
        //Assert
        XCTAssertEqual(value, "/work_times")
    }
    
    func testValue_user() {
        //Act
        let value = Endpoint.user(12).value
        //Assert
        XCTAssertEqual(value, "/users/12")
    }
}
