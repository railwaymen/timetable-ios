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
    
    override func setUp() {
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.calendarMock = CalendarMock()
        self.dispatchGroupMock = DispatchGroupMock()
        self.dispatchGroupFactoryMock = DispatchGroupFactoryMock()
        self.dispatchGroupFactoryMock.createDispatchGroupReturnValue = self.dispatchGroupMock
        self.contentProvider = WorkTimesListContentProvider(apiClient: self.apiClientMock,
                                                            accessService: self.accessServiceMock,
                                                            calendar: self.calendarMock,
                                                            dispatchGroupFactory: self.dispatchGroupFactoryMock)
        super.setUp()
    }
    
    func testFetchWorkTimeDataMakesRequest() {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.contentProvider.fetchWorkTimesData(for: nil) { _ in
            XCTFail()
        }
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 0)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        XCTAssertEqual(self.apiClientMock.fetchWorkTimesParams.count, 1)
        XCTAssertEqual(self.apiClientMock.fetchMatchingFullTimeParams.count, 1)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsNil() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsInvalid_dateComponentsFails() throws {
        //Arrange
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.calendarMock.dateComponentsReturnValue = dateComponents
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileGivenDateIsInvalid_dateFromComponentsFails() throws {
        //Arrange
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.calendarMock.dateComponentsReturnValue = dateComponents
        let startOfMonth = try Calendar.current.date(from: dateComponents).unwrap()
        self.calendarMock.dateFromDateComponentsReturnValue = startOfMonth
        let date = try Calendar.current.date(from: dateComponents).unwrap()
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 2
        //Act
        self.contentProvider.fetchWorkTimesData(for: date) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileFetchWorkTimesFinishWithError() throws {
        //Arrange
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 1
        var expectedError: Error?
        let error = TestError(message: "Fetching Work Times Error")
        
        let matchingFullTimeData = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeFullResponse)
        let matchingFullTime = try self.decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
        //Act
        self.contentProvider.fetchWorkTimesData(for: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        XCTAssertEqual(expectedError as? TestError, error)
    }
    
    func testFetchWorkTimeDataWhileFetchWorkTimesSucceed() throws {
        //Arrange
        var dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        let startOfMonth = try Calendar.current.date(from: dateComponents).unwrap()
        self.accessServiceMock.getLastLoggedInUserIdentifierReturnValue = 1
        self.calendarMock.dateComponentsReturnValue = dateComponents
        self.calendarMock.dateFromDateComponentsReturnValue = startOfMonth
        dateComponents.day = 28
        let endOfMonth = try Calendar.current.date(from: dateComponents).unwrap()
        self.calendarMock.dateByAddingCalendarComponentReturnValue = endOfMonth
        
        var expectedResponse: ([DailyWorkTime], MatchingFullTimeDecoder)?
    
        let date = try Calendar.current.date(from: dateComponents).unwrap()
        
        let workTimesData = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: workTimesData)
        
        let matchingFullTimeData = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeFullResponse)
        let matchingFullTime = try self.decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
        //Act
        self.contentProvider.fetchWorkTimesData(for: date) { result in
            switch result {
            case .success(let response):
                expectedResponse = response
            case .failure:
                XCTFail()
            }
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.success(workTimes))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        XCTAssertEqual(expectedResponse?.0.count, 1)
        XCTAssertEqual(try (expectedResponse?.1).unwrap(), matchingFullTime)
    }
    
    func testDelete() throws {
        //Arrange
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTime = try self.decoder.decode([WorkTimeDecoder].self, from: data).first.unwrap()
        var completionResult: Result<Void, Error>?
        //Act
        self.contentProvider.delete(workTime: workTime) { result in
            completionResult = result
        }
        self.apiClientMock.deleteWorkTimeParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.apiClientMock.deleteWorkTimeParams.count, 1)
        switch completionResult {
        case .some(.success): break
        default: XCTFail()
        }
    }
}
