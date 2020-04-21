//
//  WorkTimesListContentProviderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesListContentProviderTests: XCTestCase {
    private let matchingFullTimeDecoderFactory = MatchingFullTimeDecoderFactory()
    private let workTimeDecoderFactory = WorkTimeDecoderFactory()
    private let simpleProjectRecordDecoderFactory = SimpleProjectRecordDecoderFactory()
    
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var calendarMock: CalendarMock!
    private var dispatchGroupMock: DispatchGroupMock!
    private var dispatchGroupFactoryMock: DispatchGroupFactoryMock!
    
    override func setUp() {
        super.setUp()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.calendarMock = CalendarMock()
        self.dispatchGroupMock = DispatchGroupMock()
        self.dispatchGroupFactoryMock = DispatchGroupFactoryMock()
        self.dispatchGroupFactoryMock.createDispatchGroupReturnValue = self.dispatchGroupMock
    }
}

// MARK: - fetchWorkTimesData(for:completion:)
extension WorkTimesListContentProviderTests {
    func testFetchWorkTimeDataMakesRequest() {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        //Act
        sut.fetchWorkTimesData(for: Date()) { _ in
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
        let sut = self.buildSUT()
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
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
        let sut = self.buildSUT()
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.calendarMock.dateComponentsReturnValue = dateComponents
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
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
        let sut = self.buildSUT()
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.calendarMock.dateComponentsReturnValue = dateComponents
        let date = try self.buildDate(dateComponents)
        self.calendarMock.dateFromDateComponentsReturnValue = date
        
        var expectedError: Error?
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        //Act
        sut.fetchWorkTimesData(for: date) { result in
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
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 1
        var expectedError: Error?
        let error = TestError(message: "Fetching Work Times Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
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
        let sut = self.buildSUT()
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 1
        self.calendarMock.dateComponentsReturnValue = dateComponents
        self.calendarMock.dateFromDateComponentsReturnValue = try self.buildDate(dateComponents)
        self.calendarMock.dateByAddingCalendarComponentReturnValue = try self.buildDate(year: 2019, month: 2, day: 28)
        
        var expectedResponse: ([DailyWorkTime], MatchingFullTimeDecoder)?
        let date = try self.buildDate(dateComponents)
        let workTimes = try self.buildWorkTimes()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        //Act
        sut.fetchWorkTimesData(for: date) { result in
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
        XCTAssertEqual(try XCTUnwrap(expectedResponse?.1), matchingFullTime)
    }
}

// MARK: - delete(workTime:completion:)
extension WorkTimesListContentProviderTests {
    func testDelete() throws {
        //Arrange
        let sut = self.buildSUT()
        let project = try self.simpleProjectRecordDecoderFactory.build()
        let workTime = try self.workTimeDecoderFactory.build(wrapper: WorkTimeDecoderFactory.Wrapper(project: project))
        var completionResult: WorkTimesListDeleteResult?
        //Act
        sut.delete(workTime: workTime) { result in
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

// MARK: - Private
extension WorkTimesListContentProviderTests {
    private func buildSUT() -> WorkTimesListContentProvider {
        return WorkTimesListContentProvider(
            apiClient: self.apiClientMock,
            accessService: self.accessServiceMock,
            calendar: self.calendarMock,
            dispatchGroupFactory: self.dispatchGroupFactoryMock)
    }
    
    private func buildMatchingFullTimeDecoder() throws -> MatchingFullTimeDecoder {
        let accountingPeriod = try self.matchingFullTimeDecoderFactory.buildPeriod()
        return try self.matchingFullTimeDecoderFactory.build(
            accountingPeriod: accountingPeriod,
            shouldWorked: 120)
    }
    
    private func buildWorkTimes() throws -> [WorkTimeDecoder] {
        let project = try self.simpleProjectRecordDecoderFactory.build()
        return [
            try self.workTimeDecoderFactory.build(wrapper: WorkTimeDecoderFactory.Wrapper(id: 1, project: project)),
            try self.workTimeDecoderFactory.build(wrapper: WorkTimeDecoderFactory.Wrapper(id: 2, project: project))
        ]
    }
}
