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
    func testRestlerEndpointValue_matchingFullTime() {
        //Act
        let value = Endpoint.matchingFullTime.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/accounting_periods/matching_fulltime")
    }
    
    func testRestlerEndpointValue_projects() {
        //Act
        let value = Endpoint.projects.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/projects")
    }
    
    func testRestlerEndpointValue_projectsSimpleList() {
        //Act
        let value = Endpoint.projectsSimpleList.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/projects/simple")
    }
    
    func testRestlerEndpointValue_signIn() {
        //Act
        let value = Endpoint.signIn.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/users/sign_in")
    }
    
    func testRestlerEndpointValue_workTime() {
        //Act
        let value = Endpoint.workTime(1).restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/work_times/1")
    }
    
    func testRestlerEndpointValue_workTimes() {
        //Act
        let value = Endpoint.workTimes.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/work_times")
    }
    
    func testRestlerEndpointValue_user() {
        //Act
        let value = Endpoint.user(12).restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/users/12")
    }
}
