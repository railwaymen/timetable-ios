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

// MARK: - stringValue: String
extension EndpointTests {
    func testStringValue_matchingFullTime() {
        //Act
        let value = Endpoint.matchingFullTime.stringValue
        //Assert
        XCTAssertEqual(value, "/accounting_periods/matching_fulltime")
    }
    
    func testStringValue_projects() {
        //Act
        let value = Endpoint.projects.stringValue
        //Assert
        XCTAssertEqual(value, "/projects")
    }
    
    func testStringValue_projectsSimpleList() {
        //Act
        let value = Endpoint.projectsSimpleList.stringValue
        //Assert
        XCTAssertEqual(value, "/projects/simple")
    }
    
    func testStringValue_signIn() {
        //Act
        let value = Endpoint.signIn.stringValue
        //Assert
        XCTAssertEqual(value, "/users/sign_in")
    }
    
    func testStringValue_workTime() {
        //Act
        let value = Endpoint.workTime(1).stringValue
        //Assert
        XCTAssertEqual(value, "/work_times/1")
    }
    
    func testStringValue_workTimes() {
        //Act
        let value = Endpoint.workTimes.stringValue
        //Assert
        XCTAssertEqual(value, "/work_times")
    }
    
    func testStringValue_user() {
        //Act
        let value = Endpoint.user(12).stringValue
        //Assert
        XCTAssertEqual(value, "/users/12")
    }
}
