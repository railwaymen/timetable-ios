//
//  EndpointsTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 03/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class EndpointsTests: XCTestCase {}

// MARK: - value: String
extension EndpointsTests {
    func testValue_matchingFullTime() {
        //Act
        let value = Endpoints.matchingFullTime.value
        //Assert
        XCTAssertEqual(value, "/accounting_periods/matching_fulltime")
    }
    
    func testValue_projects() {
        //Act
        let value = Endpoints.projects.value
        //Assert
        XCTAssertEqual(value, "/projects")
    }
    
    func testValue_projectsSimpleList() {
        //Act
        let value = Endpoints.projectsSimpleList.value
        //Assert
        XCTAssertEqual(value, "/projects/simple")
    }
    
    func testValue_signIn() {
        //Act
        let value = Endpoints.signIn.value
        //Assert
        XCTAssertEqual(value, "/users/sign_in")
    }
    
    func testValue_workTime() {
        //Act
        let value = Endpoints.workTime(1).value
        //Assert
        XCTAssertEqual(value, "/work_times/1")
    }
    
    func testValue_workTimes() {
        //Act
        let value = Endpoints.workTimes.value
        //Assert
        XCTAssertEqual(value, "/work_times")
    }
    
    func testValue_user() {
        //Act
        let value = Endpoints.user(12).value
        //Assert
        XCTAssertEqual(value, "/users/12")
    }
}
