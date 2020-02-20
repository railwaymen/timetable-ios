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
// swiftlint:disable type_body_length
class WorkTimesListViewModelTests: XCTestCase {
    private var userInterfaceMock: WorkTimesListViewControllerMock!
    private var coordinatorMock: WorkTimesListCoordinatorMock!
    private var contentProvider: WorkTimesListContentProviderMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var messagePresenterMock: MessagePresenterMock!

    override func setUp() {
        super.setUp()
        self.userInterfaceMock = WorkTimesListViewControllerMock()
        self.coordinatorMock = WorkTimesListCoordinatorMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.contentProvider = WorkTimesListContentProviderMock()
        self.calendarMock = CalendarMock()
        self.messagePresenterMock = MessagePresenterMock()
    }
    
    func testNumberOfSectionsOnInitialization() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        let sections = sut.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 0)
    }
    
    func testNumberOfSectionsAfterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let sections = sut.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 1)
    }
    
    func testNumberOfRowsInSectionOnInitialization() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        let rows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 0)
    }
    
    func testNumberOfRowsInSectionAfterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let rows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 2)
    }
    
    func testViewDidLoad() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
    }
    
    func testViewDidLoadFetchWorkTimesShowsActivityIndicatorBeforeFetch() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewDidLoadFetchWorkTimesHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewDidLoadFetchWorkTimesHidesActivityIndicatorAfterFailedFetch() throws {
        //Arrange
        let error = TestError(message: "Error")
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.failure(error))
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }

    func testViewDidLoadRunsFetchWorkTimesSuccessCallsUpdateViewOnUserInterface() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.count, 0)
    }
    
    func testViewDidLoadRunsFetchWorkTimesSuccessCallsShowTableViewOnUserInterface() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.showTableViewParams.count, 1)
    }
    
    func testViewDidLoadRunsFetchWorkTimesFailureCallsShowErrorViewOnUserInterface() throws {
        //Arrange
        let error = TestError(message: "Error")
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
    
    func testViewWillAppearRunsFetchWorkTimesFinishWithError() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let sut = try self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.failure(expectedError))
        //Assert
        let error = try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? TestError)
        XCTAssertEqual(error, expectedError)
    }
    
    func testViewRequestForPreviousMonthWhileSelectedMonthIsNilValue() throws {
        //Arrange
        let sut = try self.buildSUT(isSelectedDate: false)
        //Act
        sut.viewRequestForPreviousMonth()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.updateMatchingFullTimeLabelsParams.isEmpty)
    }
    
    func testViewRequestForPreviousMonthWhileSelectedMonth() throws {
        //Arrange
        let sut = try self.buildSUT()
        let components = DateComponents(year: 2019, month: 1, day: 1)
        self.calendarMock.dateByAddingDateComponentsReturnValue = try self.buildDate(components)
        self.calendarMock.dateComponentsReturnValue = components
        //Act
        sut.viewRequestForPreviousMonth()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorParams.last?.currentDateString, "Jan 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorParams.last?.nextDateString, "Jan 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorParams.last?.previousDateString, "Jan 2019")
    }
    
    func testViewRequestForNextMonthWhileSelectedMonthIsNilValue() throws {
        //Act
        let sut = try self.buildSUT(isSelectedDate: false)
        sut.viewRequestForPreviousMonth()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.updateMatchingFullTimeLabelsParams.isEmpty)
    }
    
    func testViewRequestForNextMonthWhileSelectedMonth() throws {
        //Arrange
        let sut = try self.buildSUT()
        self.calendarMock.dateByAddingDateComponentsReturnValue = try self.buildDate(year: 2019, month: 1, day: 1)
        self.calendarMock.dateComponentsReturnValue = DateComponents(year: 2019, month: 3)
        //Act
        sut.viewRequestForNextMonth()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorParams.last?.currentDateString, "Mar 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorParams.last?.nextDateString, "Mar 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorParams.last?.previousDateString, "Mar 2019")
    }
    
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
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.configure(mockedCell, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(mockedCell.configureParams.count, 1)
    }
    
    func testViewRequestForHeaderModelOnInitialization() throws {
        //Arrange
        let sut = try self.buildSUT()
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        //Act
        let headerViewModel = sut.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNil(headerViewModel)
    }
    
    func testViewRequestForHeaderModelAfterFetchingWorkTimes() throws {
        //Arrange
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let headerViewModel = sut.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNotNil(headerViewModel)
    }
    
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
    
    func testViewRequestToDeleteWorkTime_errorResponse() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            //Assert
            XCTAssertFalse(completed)
        }
        self.contentProvider.deleteWorkTimeParams.last?.completion(.failure(expectedError))
    }
    
    func testViewRequestToDeleteWorkTime_succeed() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            //Assert
            XCTAssertTrue(completed)
        }
        self.contentProvider.deleteWorkTimeParams.last?.completion(.success(Void()))
    }

    func testViewRequestForCellTypeBeforeViewWillAppear() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let sut = try self.buildSUT()
        //Act
        let type = sut.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .standard)
    }
    
    func testViewRequestForCellType() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let matchingFullTimeData = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeFullResponse)
        let matchingFullTime = try self.decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
        let date = try self.buildDate(year: 2018, month: 11, day: 21)
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let type = sut.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .taskURL)
    }
    
    func testViewRequestForNewWorkTimeView() throws {
        //Arrange
        let button = UIButton()
        let sut = try self.buildSUT()
        //Act
        sut.viewRequestForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.flowType, .newEntry(lastTask: nil))
    }
    
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
        let workTime = try XCTUnwrap(dailyWorkTime.workTimes.first)
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.sourceView, cell)
        guard case let .editEntry(editedTask) = self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.flowType else { return XCTFail() }
        XCTAssertEqual(editedTask.workTimeIdentifier, workTime.identifier)
        XCTAssertEqual(editedTask.project, workTime.project)
        XCTAssertEqual(editedTask.body, workTime.body)
        XCTAssertEqual(editedTask.url?.absoluteString, workTime.task)
        XCTAssertEqual(editedTask.day, dailyWorkTime.day)
        XCTAssertEqual(editedTask.startsAt, workTime.startsAt)
        XCTAssertEqual(editedTask.endsAt, workTime.endsAt)
    }
    
    func testViewRequestToDuplicate() throws {
        //Arrange
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = UITableViewCell()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let duplicatedWorkTime = dailyWorkTime.workTimes[1]
        let firstWorkTime = dailyWorkTime.workTimes[0]
        let sut = try self.buildSUT()
        sut.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataParams.last?.completion(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        sut.viewRequestToDuplicate(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.sourceView, cell)
        guard case let .duplicateEntry(duplicatedTask, lastTask) = self.coordinatorMock.workTimesRequestedForWorkTimeViewParams.last?.flowType else {
            return XCTFail()
        }
        XCTAssertEqual(duplicatedTask.workTimeIdentifier, duplicatedWorkTime.identifier)
        XCTAssertEqual(duplicatedTask.project, duplicatedWorkTime.project)
        XCTAssertEqual(duplicatedTask.body, duplicatedWorkTime.body)
        XCTAssertEqual(duplicatedTask.url?.absoluteString, duplicatedWorkTime.task)
        XCTAssertEqual(duplicatedTask.day, dailyWorkTime.day)
        XCTAssertEqual(duplicatedTask.startsAt, duplicatedWorkTime.startsAt)
        XCTAssertEqual(duplicatedTask.endsAt, duplicatedWorkTime.endsAt)
        
        XCTAssertEqual(lastTask?.workTimeIdentifier, firstWorkTime.identifier)
        XCTAssertEqual(lastTask?.project, firstWorkTime.project)
        XCTAssertEqual(lastTask?.body, firstWorkTime.body)
        XCTAssertEqual(lastTask?.url?.absoluteString, firstWorkTime.task)
        XCTAssertEqual(lastTask?.day, dailyWorkTime.day)
        XCTAssertEqual(lastTask?.startsAt, firstWorkTime.startsAt)
        XCTAssertEqual(lastTask?.endsAt, firstWorkTime.endsAt)
    }
    
    func testViewRequestToRefreshCallsFetch() throws {
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
    
    func testViewRequestToRefreshCallsCompletionOnFailedRequest() throws {
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
    
    func testViewRequestToRefreshCallsCompletionOnSuccessfulRequest() throws {
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
            messagePresenter: self.messagePresenterMock)
    }
    
    private func buildMatchingFullTimeDecoder() throws -> MatchingFullTimeDecoder {
        let matchingFullTimeData = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeFullResponse)
        return try self.decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
    }
    
    private func buildDailyWorkTime() throws -> DailyWorkTime {
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let date = try self.buildDate(year: 2018, month: 11, day: 21)
        return DailyWorkTime(day: date, workTimes: workTimes)
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
