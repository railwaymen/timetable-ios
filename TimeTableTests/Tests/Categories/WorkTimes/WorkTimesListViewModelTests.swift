//
//  WorkTimesListViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable file_length
class WorkTimesListViewModelTests: XCTestCase {
    private let matchingFullTimeDecoderFactory = MatchingFullTimeDecoderFactory()
    private let workTimeDecoderFactory = WorkTimeDecoderFactory()
    
    private var userInterfaceMock: WorkTimesListViewControllerMock!
    private var coordinatorMock: WorkTimesListCoordinatorMock!
    private var contentProvider: WorkTimesListContentProviderMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var messagePresenterMock: MessagePresenterMock!
    private var notificationCenterMock: NotificationCenterMock!

    override func setUp() {
        super.setUp()
        self.userInterfaceMock = WorkTimesListViewControllerMock()
        self.coordinatorMock = WorkTimesListCoordinatorMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.contentProvider = WorkTimesListContentProviderMock()
        self.calendarMock = CalendarMock()
        self.messagePresenterMock = MessagePresenterMock()
        self.notificationCenterMock = NotificationCenterMock()
    }
}

// MARK: - numberOfSections()
extension WorkTimesListViewModelTests {
    func testNumberOfSections_beforeFetch() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        let sections = sut.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 0)
    }
    
    func testNumberOfSections_afterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let sections = sut.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 1)
    }
}

// MARK: - numberOfRows(in section: Int) -> Int
extension WorkTimesListViewModelTests {
    func testNumberOfRowsInSection_beforeFetch() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        let rows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 0)
    }
    
    func testNumberOfRowsInSection_afterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let rows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 2)
    }
}
 
// MARK: - viewDidLoad()
extension WorkTimesListViewModelTests {
    func testViewDidLoad_setsUpUserInterface() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
    }
}

// MARK: - viewWillAppear()
extension WorkTimesListViewModelTests {
    func testViewWillAppear_fetchWorkTimes_beforeFetch_showsActivityIndicator() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    // MARK: After Successful Fetch
    func testViewWillAppear_fetchWorkTimes_success_hidesActivityIndicator() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }

    func testViewWillAppear_fetchWorkTimes_success_beforeUILayout_doesNotUpdateUI() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.performBatchUpdatesParams.count, 0)
        XCTAssertEqual(self.userInterfaceMock.reloadDataParams.count, 0)
    }
    
    func testViewWillAppear_fetchWorkTimes_success_afterUILayout_updatesUI() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        sut.viewDidLayoutSubviews()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.performBatchUpdatesParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.reloadDataParams.count, 1)
    }
    
    func testViewWillAppear_fetchWorkTimes_success_showsTableView() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.showTableViewParams.count, 1)
    }
    
    // MARK: After Failed Fetch
    func testViewWillAppear_fetchWorkTimes_failure_hidesActivityIndicator() throws {
        //Arrange
        let error = TestError(message: "Error")
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.failure(error))
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewWillAppear_fetchWorkTimes_failure_showsErrorView() throws {
        //Arrange
        let error = TestError(message: "Error")
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
    
    func testViewWillAppear_fetchWorkTimes_failure_passesErrorToErrorHandler() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let sut = try self.buildSUT()
        //Act
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.failure(expectedError))
        //Assert
        let error = try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? TestError)
        XCTAssertEqual(error, expectedError)
    }
}

// MARK: - configure(_ cell: WorkTimeTableViewCellable, for indexPath: IndexPath)
extension WorkTimesListViewModelTests {
    func testConfigureCell_withoutWorkTimes() throws {
        //Arrange
        let sut = try self.buildSUT()
        let mockedCell = WorkTimeCellViewMock()
        //Act
        sut.configure(mockedCell, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(mockedCell.configureParams.count, 0)
    }
    
    func testConfigureCell_afterFetchingWorkTimes() throws {
        //Arrange
        let mockedCell = WorkTimeCellViewMock()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.configure(mockedCell, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(mockedCell.configureParams.count, 1)
    }
}

// MARK: - viewRequestForHeaderModel(at:header:)
extension WorkTimesListViewModelTests {
    func testViewRequestForHeaderModel_beforeFetch() throws {
        //Arrange
        let sut = try self.buildSUT()
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        //Act
        let headerViewModel = sut.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNil(headerViewModel)
    }
    
    func testViewRequestForHeaderModel_afterFetchingWorkTimes() throws {
        //Arrange
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let headerViewModel = sut.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNotNil(headerViewModel)
    }
}

// MARK: - viewRequestToDelete(at:completion:)
extension WorkTimesListViewModelTests {
    func testViewRequestToDeleteWorkTime_invalidIndexPath() throws {
        //Arrange
        let sut = try self.buildSUT()
        var requestCompleted: Bool?
        //Act
        sut.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            requestCompleted = completed
        }
        //Assert
        XCTAssertFalse(try XCTUnwrap(requestCompleted))
    }
    
    func testViewRequestToDeleteWorkTime_promptsForConfirmation() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        var requestCompleted: Bool?
        //Act
        sut.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            requestCompleted = completed
        }
        //Assert
        XCTAssertNil(requestCompleted)
        XCTAssertEqual(self.messagePresenterMock.requestDecisionParams.count, 1)
    }
    
    func testViewRequestToDeleteWorkTime_declinedDeletion() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        var requestCompleted: Bool?
        //Act
        sut.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            requestCompleted = completed
        }
        try XCTUnwrap(self.messagePresenterMock.requestDecisionParams.last?.cancelButtonConfig.action)()
        //Assert
        XCTAssertFalse(try XCTUnwrap(requestCompleted))
    }
    
    func testViewRequestToDeleteWorkTime_confirmedDeletion_requestFailure() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        var requestCompleted: Bool?
        //Act
        sut.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            requestCompleted = completed
        }
        try XCTUnwrap(self.messagePresenterMock.requestDecisionParams.last?.confirmButtonConfig.action)()
        self.contentProvider.deleteWorkTimeParams.last?.completion(.failure(expectedError))
        //Assert
        XCTAssertFalse(try XCTUnwrap(requestCompleted))
    }
    
    func testViewRequestToDeleteWorkTime_confirmedDeletion_requestSuccess() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        var requestCompleted: Bool?
        //Act
        sut.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            requestCompleted = completed
        }
        try XCTUnwrap(self.messagePresenterMock.requestDecisionParams.last?.confirmButtonConfig.action)()
        self.contentProvider.deleteWorkTimeParams.last?.completion(.success(Void()))
        try XCTUnwrap(self.userInterfaceMock.performBatchUpdatesParams.last?.updates)()
        //Assert
        XCTAssertTrue(try XCTUnwrap(requestCompleted))
    }
}

// MARK: - viewRequestForCellType(at:)
extension WorkTimesListViewModelTests {
    func testViewRequestForCellType_beforeFetch() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let sut = try self.buildSUT()
        //Act
        let type = sut.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .standard)
    }
    
    func testViewRequestForCellType_afterFetch() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let dailyWorkTime = try self.buildDailyWorkTime()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let type = sut.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .taskURL)
    }
}

// MARK: - viewRequestForNewWorkTimeView(sourceView:)
extension WorkTimesListViewModelTests {
    func testViewRequestForNewWorkTimeView() throws {
        //Arrange
        let button = UIButton()
        let sut = try self.buildSUT()
        //Act
        sut.viewRequestForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.flowType, .newEntry(lastTask: nil))
    }
}
 
// MARK: - viewRequestedForEditEntry(sourceView:at:)
extension WorkTimesListViewModelTests {
    func testViewRequestedForEditEntry_withoutDailyWorkTimes() throws {
        //Arrange
        let cell = UITableViewCell()
        let sut = try self.buildSUT()
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertTrue(self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.isEmpty)
    }
    
    func testViewRequestedForEditEntry_withDailyWorkTimes() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = UITableViewCell()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let workTime = try XCTUnwrap(dailyWorkTime.workTimes[safeIndex: 0])
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.sourceView, cell)
        let flowType = self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.flowType
        guard case let .editEntry(editedTask) = flowType else { return XCTFail() }
        XCTAssertEqual(editedTask.workTimeID, workTime.id)
        XCTAssertEqual(editedTask.project, workTime.project)
        XCTAssertEqual(editedTask.body, workTime.body)
        XCTAssertEqual(editedTask.url?.absoluteString, workTime.task)
        XCTAssertEqual(editedTask.day, dailyWorkTime.day)
        XCTAssertEqual(editedTask.startsAt, workTime.startsAt)
        XCTAssertEqual(editedTask.endsAt, workTime.endsAt)
    }
}

// MARK: - viewRequestToDuplicate(sourceView:at:)
extension WorkTimesListViewModelTests {
    func testViewRequestToDuplicate() throws {
        //Arrange
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = UITableViewCell()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let duplicatedWorkTime = dailyWorkTime.workTimes[safeIndex: 1]
        let firstWorkTime = dailyWorkTime.workTimes[safeIndex: 0]
        let sut = try self.buildSUT()
        sut.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.viewRequestToDuplicate(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.sourceView, cell)
        let flowType = self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.flowType
        guard case let .duplicateEntry(duplicatedTask, lastTask) = flowType else { return XCTFail() }
        XCTAssertEqual(duplicatedTask.workTimeID, duplicatedWorkTime?.id)
        XCTAssertEqual(duplicatedTask.project, duplicatedWorkTime?.project)
        XCTAssertEqual(duplicatedTask.body, duplicatedWorkTime?.body)
        XCTAssertEqual(duplicatedTask.url?.absoluteString, duplicatedWorkTime?.task)
        XCTAssertEqual(duplicatedTask.day, dailyWorkTime.day)
        XCTAssertEqual(duplicatedTask.startsAt, duplicatedWorkTime?.startsAt)
        XCTAssertEqual(duplicatedTask.endsAt, duplicatedWorkTime?.endsAt)
        
        XCTAssertEqual(lastTask?.workTimeID, firstWorkTime?.id)
        XCTAssertEqual(lastTask?.project, firstWorkTime?.project)
        XCTAssertEqual(lastTask?.body, firstWorkTime?.body)
        XCTAssertEqual(lastTask?.url?.absoluteString, firstWorkTime?.task)
        XCTAssertEqual(lastTask?.day, dailyWorkTime.day)
        XCTAssertEqual(lastTask?.startsAt, firstWorkTime?.startsAt)
        XCTAssertEqual(lastTask?.endsAt, firstWorkTime?.endsAt)
    }
}

// MARK: - viewRequestToRefresh(completion:)
extension WorkTimesListViewModelTests {
    func testViewRequestToRefresh_callsFetch() throws {
        //Arrange
        let sut = try self.buildSUT()
        var completionCalledCount = 0
        //Act
        sut.viewRequestToRefresh {
            completionCalledCount += 1
        }
        //Assert
        XCTAssertEqual(self.contentProvider.fetchWorkTimesDataParams.count, 1)
        XCTAssertEqual(completionCalledCount, 0)
    }
    
    func testViewRequestToRefresh_failedRequest_callsCompletion() throws {
        //Arrange
        let sut = try self.buildSUT()
        var completionCalledCount = 0
        //Act
        sut.viewRequestToRefresh {
            completionCalledCount += 1
        }
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.failure(TestError(message: "Error")))
        //Assert
        XCTAssertEqual(completionCalledCount, 1)
    }
    
    func testViewRequestToRefresh_successfulRequest_callsCompletion() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        var completionCalledCount = 0
        //Act
        sut.viewRequestToRefresh {
            completionCalledCount += 1
        }
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertEqual(completionCalledCount, 1)
    }
}

// MARK: - Private
extension WorkTimesListViewModelTests {
    private func buildSUT(isSelectedDate: Bool = true) throws -> WorkTimesListViewModel {
        let components = DateComponents(year: 2019, month: 2, day: 2)
        self.calendarMock.dateComponentsReturnValue = components
        if isSelectedDate {
            self.calendarMock.dateFromDateComponentsReturnValue = try self.buildDate(components)
        }
        return WorkTimesListViewModel(
            userInterface: self.userInterfaceMock,
            coordinator: self.coordinatorMock,
            contentProvider: self.contentProvider,
            errorHandler: self.errorHandlerMock,
            calendar: self.calendarMock,
            messagePresenter: self.messagePresenterMock,
            notificationCenter: self.notificationCenterMock)
    }
    
    private func buildMatchingFullTimeDecoder() throws -> MatchingFullTimeDecoder {
        let accountingPeriod = try self.matchingFullTimeDecoderFactory.buildPeriod()
        return try self.matchingFullTimeDecoderFactory.build(accountingPeriod: accountingPeriod, shouldWorked: 360)
    }
    
    private func buildWorkTimesDecoder(id: Int64, startsAt: Date, endsAt: Date) throws -> WorkTimeDecoder {
        let project = try SimpleProjectRecordDecoderFactory().build()
        let wrapper = WorkTimeDecoderFactory.Wrapper(
            id: id,
            startsAt: startsAt,
            endsAt: endsAt,
            body: "body",
            taskPreview: "task preview",
            project: project)
        return try self.workTimeDecoderFactory.build(wrapper: wrapper)
    }
    
    private func buildDailyWorkTime() throws -> DailyWorkTime {
        let workTimes = [
            try self.buildWorkTimesDecoder(
                id: 1,
                startsAt: self.startsAt(hour: 15),
                endsAt: self.endsAt(hour: 16)),
            try self.buildWorkTimesDecoder(
                id: 2,
                startsAt: self.startsAt(hour: 12),
                endsAt: self.endsAt(hour: 14))
        ]
        return DailyWorkTime(day: Date(), workTimes: workTimes)
    }
    
    private func startsAt(hour: Int) throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2018,
            month: 11,
            day: 21,
            hour: hour,
            minute: 0,
            second: 0)
    }
    
    private func endsAt(hour: Int) throws -> Date {
        return try self.buildDate(
            timeZone: TimeZone(secondsFromGMT: 0)!,
            year: 2018,
            month: 11,
            day: 21,
            hour: hour,
            minute: 0,
            second: 0)
    }
}
// swiftlint:enable file_length
