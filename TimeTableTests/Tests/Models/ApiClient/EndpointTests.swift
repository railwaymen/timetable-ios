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
    func testRestlerEndpointValue_accountingPeriods() {
        //Arrange
        let sut: Endpoint = .accountingPeriods
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/accounting_periods")
    }
    
    func testRestlerEndpointValue_matchingFullTime() {
        //Arrange
        let sut: Endpoint = .matchingFullTime
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/accounting_periods/matching_fulltime")
    }
    
    func testRestlerEndpointValue_projects() {
        //Arrange
        let sut: Endpoint = .projects
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/projects")
    }
    
    func testRestlerEndpointValue_projectsSimpleList() {
        //Arrange
        let sut: Endpoint = .projectsSimpleList
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/projects/simple")
    }
    
    func testRestlerEndpointValue_remoteWork() {
        //Arrange
        let sut: Endpoint = .remoteWork(54)
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/remote_works/54")
    }
    
    func testRestlerEndpointValue_remoteWorks() {
        //Arrange
        let sut: Endpoint = .remoteWorks
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/remote_works")
    }
    
    func testRestlerEndpointValue_signIn() {
        //Arrange
        let sut: Endpoint = .signIn
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/users/sign_in")
    }
    
    func testRestlerEndpointValue_tags() {
        //Arrange
        let sut: Endpoint = .tags
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/projects/tags")
    }
    
    func testRestlerEndpointValue_workTime() {
        //Arrange
        let sut: Endpoint = .workTime(1)
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/work_times/1")
    }
    
    func testRestlerEndpointValue_workTimes() {
        //Arrange
        let sut: Endpoint = .workTimes
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/work_times")
    }
    
    func testRestlerEndpointValue_workTimesCreateWithFillingGaps() {
        //Arrange
        let sut: Endpoint = .workTimesCreateWithFilling
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/work_times/create_filling_gaps")
    }
    
    func testRestlerEndpointValue_user() {
        //Arrange
        let sut: Endpoint = .user(12)
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/users/12")
    }
    
    func testRestlerEndpointValue_vacation() {
        //Arrange
        let sut: Endpoint = .vacation
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/vacations")
    }
    
    func testRestlerEndpointValue_vacationDecline() {
        //Arrange
        let sut: Endpoint = .vacationDecline(2)
        //Act
        let value = sut.restlerEndpointValue
        //Assert
        XCTAssertEqual(value, "/vacations/2/self_decline")
    }
}
