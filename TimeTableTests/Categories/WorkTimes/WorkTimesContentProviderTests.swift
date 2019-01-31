//
//  WorkTimesContentProviderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesContentProviderTests: XCTestCase {
    private let timeout = TimeInterval(0.1)
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var calendarMock: CalendarMock!
    private var contentProvider: WorkTimesContentProvider!
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    private enum MatchingFullTimeResponse: String, JSONFileResource {
        case matchingFullTimeFullResponse
    }
    
    private enum WorkTimesResponse: String, JSONFileResource {
        case workTimesResponse
    }
    
    override func setUp() {
        
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.calendarMock = CalendarMock()
        self.contentProvider = WorkTimesContentProvider(apiClient: apiClientMock, accessService: accessServiceMock, calendar: calendarMock)
        super.setUp()
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsNil() throws {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 1
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        
        let expectation = self.expectation(description: "Content provider fetch")
        let fetchWorkTimesExpectation = self.expectation(description: "Work Times")
        apiClientMock.fetchWorkTimesExpectation = fetchWorkTimesExpectation.fulfill
        let fetchMatchingFullTime = self.expectation(description: "Matching Full Time")
        apiClientMock.fetchMatchingFullTimeExpectation = fetchMatchingFullTime.fulfill
        //Act
        contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                expectation.fulfill()
            }
        }
        wait(for: [fetchWorkTimesExpectation, fetchMatchingFullTime], timeout: timeout)
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.failure(error))
        wait(for: [expectation], timeout: timeout)
        //Assert
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsInvalid_dateComponentsFails() throws {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 1
        
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        calendarMock.dateComponentsReturnValue = dateComponents
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        
        let expectation = self.expectation(description: "Content provider fetch")
        let fetchWorkTimesExpectation = self.expectation(description: "Work Times")
        apiClientMock.fetchWorkTimesExpectation = fetchWorkTimesExpectation.fulfill
        let fetchMatchingFullTime = self.expectation(description: "Matching Full Time")
        apiClientMock.fetchMatchingFullTimeExpectation = fetchMatchingFullTime.fulfill
        //Act
        contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                expectation.fulfill()
            }
        }
        wait(for: [fetchWorkTimesExpectation, fetchMatchingFullTime], timeout: timeout)
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.failure(error))
        wait(for: [expectation], timeout: timeout)
        //Assert
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsInvalid_dateFromComponentsFails() throws {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 1
        
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        calendarMock.dateComponentsReturnValue = dateComponents
        let startOfMonth = try Calendar.current.date(from: dateComponents).unwrap()
        calendarMock.dateFromComponentsValue = startOfMonth
        let date = try Calendar.current.date(from: dateComponents).unwrap()
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        
        let expectation = self.expectation(description: "Content provider fetch")
        let fetchWorkTimesExpectation = self.expectation(description: "Work Times")
        apiClientMock.fetchWorkTimesExpectation = fetchWorkTimesExpectation.fulfill
        let fetchMatchingFullTime = self.expectation(description: "Matching Full Time")
        apiClientMock.fetchMatchingFullTimeExpectation = fetchMatchingFullTime.fulfill
        //Act
        contentProvider.fetchWorkTimesData(for: date) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                expectation.fulfill()
            }
        }
        wait(for: [fetchWorkTimesExpectation, fetchMatchingFullTime], timeout: timeout)
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.failure(error))
        wait(for: [expectation], timeout: timeout)
        //Assert
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileFetchWorkTimesFinishWithError() throws {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 1
        
        var expectedError: Error?
        let error = TestError(message: "Fetching Work Times Error")
        
        let matchingFullTimeData = try self.json(from: MatchingFullTimeResponse.matchingFullTimeFullResponse)
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
        
        let expectation = self.expectation(description: "Content provider fetch")
        let fetchWorkTimesExpectation = self.expectation(description: "Work Times")
        apiClientMock.fetchWorkTimesExpectation = fetchWorkTimesExpectation.fulfill
        let fetchMatchingFullTime = self.expectation(description: "Matching Full Time")
        apiClientMock.fetchMatchingFullTimeExpectation = fetchMatchingFullTime.fulfill
        //Act
        contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                expectation.fulfill()
            }
        }
        wait(for: [fetchWorkTimesExpectation, fetchMatchingFullTime], timeout: timeout)
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.success(matchingFullTime))
        wait(for: [expectation], timeout: timeout)
        //Assert
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileFetchWorkTimesSucceed() throws {
        //Arrange
        var dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        let startOfMonth = try Calendar.current.date(from: dateComponents).unwrap()
        accessServiceMock.getLastLoggedInUserIdentifierValue = 1
        calendarMock.dateComponentsReturnValue = dateComponents
        calendarMock.dateFromComponentsValue = startOfMonth
        dateComponents.day = 28
        let endOfMonth = try Calendar.current.date(from: dateComponents).unwrap()
        calendarMock.shortDateByAddingReturnValue = endOfMonth
        
        var expectedResponse: ([DailyWorkTime], MatchingFullTimeDecoder)?
    
        let date = try Calendar.current.date(from: dateComponents).unwrap()
        
        let workTimesData = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: workTimesData)
        
        let matchingFullTimeData = try self.json(from: MatchingFullTimeResponse.matchingFullTimeFullResponse)
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
        
        let expectation = self.expectation(description: "Content provider fetch")
        let fetchWorkTimesExpectation = self.expectation(description: "Work Times")
        apiClientMock.fetchWorkTimesExpectation = fetchWorkTimesExpectation.fulfill
        let fetchMatchingFullTime = self.expectation(description: "Matching Full Time")
        apiClientMock.fetchMatchingFullTimeExpectation = fetchMatchingFullTime.fulfill
        //Act
        contentProvider.fetchWorkTimesData(for: date) { result in
            switch result {
            case .success(let response):
                expectedResponse = response
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [fetchWorkTimesExpectation, fetchMatchingFullTime], timeout: timeout)
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        apiClientMock.fetchMatchingFullTimeCompletion?(.success(matchingFullTime))
        wait(for: [expectation], timeout: timeout)
        //Assert
        XCTAssertEqual(expectedResponse?.0.count, 1)
        XCTAssertEqual(try (expectedResponse?.1).unwrap(), matchingFullTime)
    }
}
