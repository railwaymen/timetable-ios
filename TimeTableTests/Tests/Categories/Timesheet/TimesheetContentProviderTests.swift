//
//  TimesheetContentProviderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimesheetContentProviderTests: XCTestCase {
    private let matchingFullTimeDecoderFactory = MatchingFullTimeDecoderFactory()
    private let workTimeDecoderFactory = WorkTimeDecoderFactory()
    private let simpleProjectRecordDecoderFactory = SimpleProjectRecordDecoderFactory()
    
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var calendarMock: CalendarMock!
    private var dispatchGroupFactoryMock: DispatchGroupFactoryMock!
    
    private var lastDispatchGroupMock: DispatchGroupMock? {
        self.dispatchGroupFactoryMock.createDispatchGroupReturnedValues.last
    }
    
    override func setUp() {
        super.setUp()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.calendarMock = CalendarMock()
        self.dispatchGroupFactoryMock = DispatchGroupFactoryMock()
    }
}

// MARK: - fetchRequiredData(for:completion:)
extension TimesheetContentProviderTests {
    func testFetchRequiredData_makesRequests() throws {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchRequiredDataResult?
        //Act
        sut.fetchRequiredData(for: Date()) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.dispatchGroupFactoryMock.createDispatchGroupParams.count, 2)
        let dispatchGroups = self.dispatchGroupFactoryMock.createDispatchGroupReturnedValues
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.leaveParams.count, 0)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.notifyParams.count, 1)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.leaveParams.count, 0)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.notifyParams.count, 1)
    }
    
    func testFetchRequiredData_fetchSimpleProjectsFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Fetching Simple Projects Error")
        let workTimes = try self.buildWorkTimes()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchRequiredDataResult?
        //Act
        sut.fetchRequiredData(for: Date()) { result in
            completionResult = result
        }
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.failure(error))
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.success(workTimes))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.dispatchGroupFactoryMock.createDispatchGroupParams.count, 2)
        let dispatchGroups = self.dispatchGroupFactoryMock.createDispatchGroupReturnedValues
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.notifyParams.count, 1)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.notifyParams.count, 1)
    }
    
    func testFetchRequiredData_fetchWorkTimesFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let projects = try self.buildSimpleProjects()
        let error = TestError(message: "Fetching Work Times Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchRequiredDataResult?
        //Act
        sut.fetchRequiredData(for: Date()) { result in
            completionResult = result
        }
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(projects))
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.dispatchGroupFactoryMock.createDispatchGroupParams.count, 2)
        let dispatchGroups = self.dispatchGroupFactoryMock.createDispatchGroupReturnedValues
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.notifyParams.count, 1)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.notifyParams.count, 1)
    }
    
    func testFetchRequiredData_fetchMatchingFulltimeFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let projects = try self.buildSimpleProjects()
        let workTimes = try self.buildWorkTimes()
        let error = TestError(message: "Fetching Matching Fulltime Error")
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchRequiredDataResult?
        //Act
        sut.fetchRequiredData(for: Date()) { result in
            completionResult = result
        }
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(projects))
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.success(workTimes))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.dispatchGroupFactoryMock.createDispatchGroupParams.count, 2)
        let dispatchGroups = self.dispatchGroupFactoryMock.createDispatchGroupReturnedValues
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.notifyParams.count, 1)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.notifyParams.count, 1)
    }
    
    func testFetchRequiredData_success() throws {
        //Arrange
        let sut = self.buildSUT()
        let projects = try self.buildSimpleProjects()
        let workTimes = try self.buildWorkTimes()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchRequiredDataResult?
        //Act
        sut.fetchRequiredData(for: Date()) { result in
            completionResult = result
        }
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(projects))
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.success(workTimes))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        let data = try XCTUnwrap(completionResult).get()
        XCTAssertEqual(data.simpleProjects, projects)
        XCTAssertEqual(data.dailyWorkTimes.count, 1)
        XCTAssertEqual(data.matchingFulltime, matchingFullTime)
        XCTAssertEqual(self.dispatchGroupFactoryMock.createDispatchGroupParams.count, 2)
        let dispatchGroups = self.dispatchGroupFactoryMock.createDispatchGroupReturnedValues
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 0]?.notifyParams.count, 1)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.enterParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.leaveParams.count, 2)
        XCTAssertEqual(dispatchGroups[safeIndex: 1]?.notifyParams.count, 1)
    }

}

// MARK: - fetchWorkTimesData(for:completion:)
extension TimesheetContentProviderTests {
    func testFetchWorkTimeData_makesRequest() {
        //Arrange
        let sut = self.buildSUT()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchResult?
        //Act
        sut.fetchWorkTimesData(for: Date()) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.dispatchGroupFactoryMock.createDispatchGroupParams.count, 1)
        XCTAssertEqual(self.lastDispatchGroupMock?.enterParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.leaveParams.count, 0)
        XCTAssertEqual(self.lastDispatchGroupMock?.notifyParams.count, 1)
        XCTAssertEqual(self.apiClientMock.fetchWorkTimesParams.count, 1)
        XCTAssertEqual(self.apiClientMock.fetchMatchingFullTimeParams.count, 1)
    }
    
    func testFetchWorkTimeData_givenDateIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Work times error")
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchResult?
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.lastDispatchGroupMock?.enterParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.leaveParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.notifyParams.count, 1)
    }
    
    func testFetchWorkTimeData_givenDateIsInvalid_dateComponentsFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Work times error")
        let dateComponents = DateComponents(year: 2019, month: 2, day: 1)
        self.calendarMock.dateComponentsReturnValue = dateComponents
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 2
        var completionResult: TimesheetFetchResult?
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.lastDispatchGroupMock?.enterParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.leaveParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.notifyParams.count, 1)
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
        var completionResult: TimesheetFetchResult?
        //Act
        sut.fetchWorkTimesData(for: date) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.lastDispatchGroupMock?.enterParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.leaveParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.notifyParams.count, 1)
    }
    
    func testFetchWorkTimeData_fetchWorkTimesFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "Fetching Work Times Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        self.accessServiceMock.getLastLoggedInUserIDReturnValue = 1
        var completionResult: TimesheetFetchResult?
        //Act
        sut.fetchWorkTimesData(for: nil) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.failure(error))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
        XCTAssertEqual(self.lastDispatchGroupMock?.enterParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.leaveParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.notifyParams.count, 1)
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
        var completionResult: TimesheetFetchResult?
        //Act
        sut.fetchWorkTimesData(for: date) { result in
            completionResult = result
        }
        self.apiClientMock.fetchWorkTimesParams.last?.completion(.success(workTimes))
        self.apiClientMock.fetchMatchingFullTimeParams.last?.completion(.success(matchingFullTime))
        //Assert
        XCTAssertEqual(self.lastDispatchGroupMock?.enterParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.leaveParams.count, 2)
        XCTAssertEqual(self.lastDispatchGroupMock?.notifyParams.count, 1)
        let expectedResponse = try XCTUnwrap(completionResult).get()
        XCTAssertEqual(expectedResponse.0.count, 1)
        XCTAssertEqual(try XCTUnwrap(expectedResponse.1), matchingFullTime)
    }
}

// MARK: - delete(workTime:completion:)
extension TimesheetContentProviderTests {
    func testDelete() throws {
        //Arrange
        let sut = self.buildSUT()
        let project = try self.simpleProjectRecordDecoderFactory.build()
        let workTime = try self.workTimeDecoderFactory.build(wrapper: WorkTimeDecoderFactory.Wrapper(project: project))
        var completionResult: TimesheetDeleteResult?
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
extension TimesheetContentProviderTests {
    private func buildSUT() -> TimesheetContentProvider {
        return TimesheetContentProvider(
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
