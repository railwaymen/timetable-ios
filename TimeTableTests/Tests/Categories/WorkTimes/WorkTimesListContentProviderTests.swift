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
    func testFetchWorkTimeData_makesRequest() {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: WorkTimesListFetchResult?
        //Act
        sut.fetchWorkTimesData(for: Date()) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 0)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        XCTAssertEqual(self.apiClientMock.fetchWorkTimesParams.count, 1)
        XCTAssertEqual(self.apiClientMock.fetchMatchingFullTimeParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    func testFetchWorkTimeData_givenDateIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: WorkTimesListFetchResult?
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testFetchWorkTimeData_givenDateIsInvalid_dateComponentsFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Work times error")
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.calendarMock.dateComponentsReturnValue = dateComponents
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: WorkTimesListFetchResult?
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testFetchWorkTimeData_givenDateIsInvalid_dateFromComponentsFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Work times error")
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        let date = try self.buildDate(dateComponents)
        self.calendarMock.dateComponentsReturnValue = dateComponents
        self.calendarMock.dateFromDateComponentsReturnValue = date
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: WorkTimesListFetchResult?
        //Act
        sut.fetchWorkTimesData(for: date) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testFetchWorkTimeData_fetchWorkTimesFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Fetching Work Times Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 1
        var completionResult: WorkTimesListFetchResult?
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testFetchWorkTimeData_fetchWorkTimesSucceeded() throws {
        //Arrange
        let sut = self.buildSUT()
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 1
        self.calendarMock.dateComponentsReturnValue = dateComponents
        self.calendarMock.dateFromDateComponentsReturnValue = try self.buildDate(dateComponents)
        self.calendarMock.dateByAddingCalendarComponentReturnValue = try self.buildDate(year: 2019, month: 2, day: 28)
        
        let date = try self.buildDate(dateComponents)
        let workTimes = try self.buildWorkTimes()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        var completionResult: WorkTimesListFetchResult?
        //Act
        sut.fetchWorkTimesData(for: date) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.success(workTimes))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        XCTAssertEqual(self.dispatchGroupMock.enterParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.leaveParams.count, 2)
        XCTAssertEqual(self.dispatchGroupMock.notifyParams.count, 1)
        let expectedResponse = try XCTUnwrap(completionResult).get()
        XCTAssertEqual(expectedResponse.0.count, 1)
        XCTAssertEqual(try XCTUnwrap(expectedResponse.1), matchingFullTime)
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
        XCTAssertNoThrow(try XCTUnwrap(completionResult).get())
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
    
    private func buildSimpleProjects() throws -> [SimpleProjectRecordDecoder] {
        [
            try self.simpleProjectRecordDecoderFactory.build(wrapper: .init(id: 0)),
            try self.simpleProjectRecordDecoderFactory.build(wrapper: .init(id: 1)),
            try self.simpleProjectRecordDecoderFactory.build(wrapper: .init(id: 2))
        ]
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
