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
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var calendarMock: CalendarMock!
    private var dispatchGroupMock: DispatchGroupMock!
    private var dispatchGroupFactoryMock: DispatchGroupFactoryMock!
    private var contentProvider: WorkTimesListContentProvider!
    
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
        apiClientMock = ApiClientMock()
        accessServiceMock = AccessServiceMock()
        calendarMock = CalendarMock()
        dispatchGroupMock = DispatchGroupMock()
        dispatchGroupFactoryMock = DispatchGroupFactoryMock()
        dispatchGroupFactoryMock.expectedDispatchGroup = dispatchGroupMock
        contentProvider = WorkTimesListContentProvider(apiClient: apiClientMock,
                                                       accessService: accessServiceMock,
                                                       calendar: calendarMock,
                                                       dispatchGroupFactory: dispatchGroupFactoryMock)
        super.setUp()
    }
    
    func testFetchWorkTimeDataMakesRequest() {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        contentProvider.fetchWorkTimesData(for: nil) { _ in
            XCTFail()
        }
        //Assert
        XCTAssertEqual(dispatchGroupMock.enterCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.leaveCalledCount, 0)
        XCTAssertEqual(dispatchGroupMock.notifyCalledCount, 1)
        XCTAssertNotNil(apiClientMock.fetchWorkTimesCompletion)
        XCTAssertNotNil(apiClientMock.fetchMatchingFullTimeCompletion)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsNil() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(dispatchGroupMock.enterCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.leaveCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.notifyCalledCount, 1)
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsInvalid_dateComponentsFails() throws {
        //Arrange
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        calendarMock.dateComponentsReturnValue = dateComponents
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(dispatchGroupMock.enterCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.leaveCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.notifyCalledCount, 1)
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsInvalid_dateFromComponentsFails() throws {
        //Arrange
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        calendarMock.dateComponentsReturnValue = dateComponents
        let startOfMonth = try Calendar.current.date(from: dateComponents).unwrap()
        calendarMock.dateFromComponentsValue = startOfMonth
        let date = try Calendar.current.date(from: dateComponents).unwrap()
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        accessServiceMock.getLastLoggedInUserIdentifierValue = 2
        //Act
        contentProvider.fetchWorkTimesData(for: date) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(dispatchGroupMock.enterCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.leaveCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.notifyCalledCount, 1)
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileFetchWorkTimesFinishWithError() throws {
        //Arrange
        accessServiceMock.getLastLoggedInUserIdentifierValue = 1
        var expectedError: Error?
        let error = TestError(message: "Fetching Work Times Error")
        
        let matchingFullTimeData = try self.json(from: MatchingFullTimeResponse.matchingFullTimeFullResponse)
        let matchingFullTime = try decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
        //Act
        contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        apiClientMock.fetchWorkTimesCompletion?(.failure(error))
        apiClientMock.fetchMatchingFullTimeCompletion?(.success(matchingFullTime))
        //Assert
        XCTAssertEqual(dispatchGroupMock.enterCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.leaveCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.notifyCalledCount, 1)
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
        //Act
        contentProvider.fetchWorkTimesData(for: date) { result in
            switch result {
            case .success(let response):
                expectedResponse = response
            case .failure:
                XCTFail()
            }
        }
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        apiClientMock.fetchMatchingFullTimeCompletion?(.success(matchingFullTime))
        //Assert
        XCTAssertEqual(dispatchGroupMock.enterCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.leaveCalledCount, 2)
        XCTAssertEqual(dispatchGroupMock.notifyCalledCount, 1)
        XCTAssertEqual(expectedResponse?.0.count, 1)
        XCTAssertEqual(try (expectedResponse?.1).unwrap(), matchingFullTime)
    }
    
    func testDelete() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTime = try self.decoder.decode([WorkTimeDecoder].self, from: data).first.unwrap()
        var completionResult: Result<Void>?
        //Act
        self.contentProvider.delete(workTime: workTime) { result in
            completionResult = result
        }
        self.apiClientMock.deleteWorkTimeCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(self.apiClientMock.deleteWorkTimeCalled)
        switch completionResult {
        case .some(.success): break
        default: XCTFail()
        }
    }
}
