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
    
    private enum WorkTimesResponse: String, JSONFileResource {
        case workTimesResponse
        case workTimesResponseNotSorted
    }
    
    private enum MatchingFullTimeResponse: String, JSONFileResource {
        case matchingFullTimeFullResponse
    }
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    override func setUp() {
        self.userInterfaceMock = WorkTimesListViewControllerMock()
        self.coordinatorMock = WorkTimesListCoordinatorMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.contentProvider = WorkTimesListContentProviderMock()
        self.calendarMock = CalendarMock()
        super.setUp()
    }
    
    func testNumberOfSectionsOnInitialization() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        let sections = viewModel.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 0)
    }
    
    func testNumberOfSectionsAfterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let sections = viewModel.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 1)
    }
    
    func testNumberOfRowsInSectionOnInitialization() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        let rows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 0)
    }
    
    func testNumberOfRowsInSectionAfterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let rows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 2)
    }
    
    func testViewDidLoad() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setUpViewCalled)
    }
    
    func testViewDidLoadFetchWorkTimesShowsActivityIndicatorBeforeFetch() throws {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchWorkTimesHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertTrue(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchWorkTimesHidesActivityIndicatorAfterFailedFetch() throws {
        //Arrange
        let error = TestError(message: "Error")
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.failure(error))
        //Assert
        XCTAssertTrue(try self.userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
    }

    func testViewDidLoadRunsFetchWorkTimesSuccessCallsUpdateViewOnUserInterface() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertTrue(self.userInterfaceMock.updateViewCalled)
    }
    
    func testViewDidLoadRunsFetchWorkTimesSuccessCallsShowTableViewOnUserInterface() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertTrue(self.userInterfaceMock.showTableViewCalled)
    }
    
    func testViewDidLoadRunsFetchWorkTimesFailureCallsShowErrorViewOnUserInterface() throws {
        //Arrange
        let error = TestError(message: "Error")
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.failure(error))
        //Assert
        XCTAssertTrue(self.userInterfaceMock.showErrorViewCalled)
    }
    
    func testViewWillAppearRunsFetchWorkTimesFinishWithError() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.failure(expectedError))
        //Assert
        let error = try (self.errorHandlerMock.throwedError as? TestError).unwrap()
        XCTAssertEqual(error, expectedError)
    }
    
    func testViewRequestForPreviousMonthWhileSelectedMonthIsNilValue() {
        //Act
        let viewModel = self.buildViewModel(isSelecteDate: false)
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertNil(self.userInterfaceMock.updateMatchingFullTimeLabelsData.duration)
        XCTAssertNil(self.userInterfaceMock.updateMatchingFullTimeLabelsData.shouldWorkHours)
        XCTAssertNil(self.userInterfaceMock.updateMatchingFullTimeLabelsData.workedHours)
    }
    
    func testViewRequestForPreviousMonthWhileSelectedMonth() throws {
        //Arrange
        let viewModel = self.buildViewModel()
        let components = DateComponents(year: 2019, month: 1, day: 1)
        let date = Calendar.current.date(from: components)
        self.calendarMock.shortDateByAddingReturnValue = date
        self.calendarMock.dateComponentsReturnValue = DateComponents(year: 2019, month: 1)
        //Act
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorData.currentDateString, "Jan 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorData.nextDateString, "Jan 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorData.previousDateString, "Jan 2019")
    }
    
    func testViewRequestForNextMonthWhileSelectedMonthIsNilValue() {
        //Act
        let viewModel = self.buildViewModel(isSelecteDate: false)
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertNil(self.userInterfaceMock.updateMatchingFullTimeLabelsData.duration)
        XCTAssertNil(self.userInterfaceMock.updateMatchingFullTimeLabelsData.shouldWorkHours)
        XCTAssertNil(self.userInterfaceMock.updateMatchingFullTimeLabelsData.workedHours)
    }
    
    func testViewRequestForNextMonthWhileSelectedMonth() throws {
        //Arrange
        let viewModel = self.buildViewModel()
        let components = DateComponents(year: 2019, month: 1, day: 1)
        let date = Calendar.current.date(from: components)
        self.calendarMock.shortDateByAddingReturnValue = date
        self.calendarMock.dateComponentsReturnValue = DateComponents(year: 2019, month: 3)
        //Act
        viewModel.viewRequestForNextMonth()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorData.currentDateString, "Mar 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorData.nextDateString, "Mar 2019")
        XCTAssertEqual(self.userInterfaceMock.updateDateSelectorData.previousDateString, "Mar 2019")
    }
    
    func testViewRequestForCellModelOnInitialization() {
        //Arrange
        let viewModel = self.buildViewModel()
        let mockedCell = WorkTimeCellViewMock()
        //Act
        let cellViewModel = viewModel.viewRequestForCellModel(at: IndexPath(row: 0, section: 0), cell: mockedCell)
        //Assert
        XCTAssertNil(cellViewModel)
    }
    
    func testViewRequestForCellModelAfterFetchingWorkTimes() throws {
        //Arrange
        let mockedCell = WorkTimeCellViewMock()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let cellViewModel = viewModel.viewRequestForCellModel(at: IndexPath(row: 0, section: 0), cell: mockedCell)
        //Assert
        XCTAssertNotNil(cellViewModel)
    }
    
    func testViewRequestForHeaderModelOnInitialization() {
        //Arrange
        let viewModel = self.buildViewModel()
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        //Act
        let headerViewModel = viewModel.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNil(headerViewModel)
    }
    
    func testViewRequestForHeaderModelAfterFetchingWorkTimes() throws {
        //Arrange
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let headerViewModel = viewModel.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNotNil(headerViewModel)
    }
    
    func testViewRequestToDeleteWorkTime_invalidIndexPath() {
        //Arrange
        let viewModel = self.buildViewModel()
        var requestCompleted: Bool?
        //Act
        viewModel.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            requestCompleted = completed
        }
        //Assert
        XCTAssertFalse(try requestCompleted.unwrap())
    }
    
    func testViewRequestToDeleteWorkTime_errorResponse() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            //Assert
            XCTAssertFalse(completed)
        }
        self.contentProvider.deleteWorkTimeCompletion?(.failure(expectedError))
    }
    
    func testViewRequestToDeleteWorkTime_succeed() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            //Assert
            XCTAssertTrue(completed)
        }
        self.contentProvider.deleteWorkTimeCompletion?(.success(Void()))
    }

    func testViewRequestForCellTypeBeforeViewWillAppear() {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let viewModel = self.buildViewModel()
        //Act
        let type = viewModel.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .standard)
    }
    
    func testViewRequestForCellType() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let matchingFullTimeData = try self.json(from: MatchingFullTimeResponse.matchingFullTimeFullResponse)
        let matchingFullTime = try self.decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
        let components = DateComponents(year: 2018, month: 11, day: 21)
        let date = try Calendar.current.date(from: components).unwrap()
        let dailyWorkTime = DailyWorkTime(day: date, workTimes: workTimes)
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let type = viewModel.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .taskURL)
    }
    
    func testViewRequestForNewWorkTimeView() {
        //Arrange
        let button = UIButton()
        let viewModel = self.buildViewModel()
        //Act
        viewModel.viewRequestForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewFlowType, .newEntry(lastTask: nil))
    }
    
    func testViewRequestedForEditEntry_withoutDailyWorkTimes() {
        //Arrange
        let cell = UITableViewCell()
        let viewModel = self.buildViewModel()
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        viewModel.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertFalse(self.coordinatorMock.workTimesRequestedForWorkTimeViewCalled)
    }
    
    func testViewRequestedForEditEntry_withDailyWorkTimes() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = UITableViewCell()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let workTime = try dailyWorkTime.workTimes.first.unwrap()
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewSourceView, cell)
        guard case let .editEntry(editedTask) = self.coordinatorMock.workTimesRequestedForWorkTimeViewFlowType else { return XCTFail() }
        XCTAssertEqual(editedTask.workTimeIdentifier, workTime.identifier)
        XCTAssertEqual(editedTask.project, workTime.project)
        XCTAssertEqual(editedTask.body, workTime.body)
        XCTAssertEqual(editedTask.url?.absoluteString, workTime.task)
        XCTAssertEqual(editedTask.day, dailyWorkTime.day)
        XCTAssertEqual(editedTask.startAt, workTime.startsAt)
        XCTAssertEqual(editedTask.endAt, workTime.endsAt)
    }
    
    func testViewRequestToDuplicate() throws {
        //Arrange
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = UITableViewCell()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let duplicatedWorkTime = dailyWorkTime.workTimes[1]
        let firstWorkTime = dailyWorkTime.workTimes[0]
        let viewModel = self.buildViewModel()
        viewModel.viewDidLoad()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestToDuplicate(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertEqual(self.coordinatorMock.workTimesRequestedForWorkTimeViewSourceView, cell)
        guard case let .duplicateEntry(duplicatedTask, lastTask) = self.coordinatorMock.workTimesRequestedForWorkTimeViewFlowType else { return XCTFail() }
        XCTAssertEqual(duplicatedTask.workTimeIdentifier, duplicatedWorkTime.identifier)
        XCTAssertEqual(duplicatedTask.project, duplicatedWorkTime.project)
        XCTAssertEqual(duplicatedTask.body, duplicatedWorkTime.body)
        XCTAssertEqual(duplicatedTask.url?.absoluteString, duplicatedWorkTime.task)
        XCTAssertEqual(duplicatedTask.day, dailyWorkTime.day)
        XCTAssertEqual(duplicatedTask.startAt, duplicatedWorkTime.startsAt)
        XCTAssertEqual(duplicatedTask.endAt, duplicatedWorkTime.endsAt)
        
        XCTAssertEqual(lastTask?.workTimeIdentifier, firstWorkTime.identifier)
        XCTAssertEqual(lastTask?.project, firstWorkTime.project)
        XCTAssertEqual(lastTask?.body, firstWorkTime.body)
        XCTAssertEqual(lastTask?.url?.absoluteString, firstWorkTime.task)
        XCTAssertEqual(lastTask?.day, dailyWorkTime.day)
        XCTAssertEqual(lastTask?.startAt, firstWorkTime.startsAt)
        XCTAssertEqual(lastTask?.endAt, firstWorkTime.endsAt)
    }
    
    func testViewRequestToRefreshCallsFetch() {
        //Arrange
        let viewModel = self.buildViewModel()
        var completionCalledCount = 0
        //Act
        viewModel.viewRequestToRefresh {
            completionCalledCount += 1
        }
        //Assert
        XCTAssertNotNil(self.contentProvider.fetchWorkTimesDataCompletion)
        XCTAssertEqual(completionCalledCount, 0)
    }
    
    func testViewRequestToRefreshCallsCompletionOnFailedRequest() {
        //Arrange
        let viewModel = self.buildViewModel()
        var completionCalledCount = 0
        //Act
        viewModel.viewRequestToRefresh {
            completionCalledCount += 1
        }
        self.contentProvider.fetchWorkTimesDataCompletion?(.failure(TestError(message: "Error")))
        //Assert
        XCTAssertEqual(completionCalledCount, 1)
    }
    
    func testViewRequestToRefreshCallsCompletionOnSuccessfulRequest() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = self.buildViewModel()
        var completionCalledCount = 0
        //Act
        viewModel.viewRequestToRefresh {
            completionCalledCount += 1
        }
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertEqual(completionCalledCount, 1)
    }
    
    // MARK: - Private
    private func buildViewModel(isSelecteDate: Bool = true) -> WorkTimesListViewModel {
        let components = DateComponents(year: 2019, month: 2, day: 2)
        self.calendarMock.dateComponentsReturnValue = components
        if isSelecteDate {
            self.calendarMock.dateFromComponentsValue = Calendar.current.date(from: components)
        }
        return WorkTimesListViewModel(userInterface: self.userInterfaceMock,
                                      coordinator: self.coordinatorMock,
                                      contentProvider: self.contentProvider,
                                      errorHandler: self.errorHandlerMock,
                                      calendar: self.calendarMock)
    }
    
    private func buildMatchingFullTimeDecoder() throws -> MatchingFullTimeDecoder {
        let matchingFullTimeData = try self.json(from: MatchingFullTimeResponse.matchingFullTimeFullResponse)
        return try self.decoder.decode(MatchingFullTimeDecoder.self, from: matchingFullTimeData)
    }
    
    private func buildDailyWorkTime() throws -> DailyWorkTime {
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let components = DateComponents(year: 2018, month: 11, day: 21)
        let date = try Calendar.current.date(from: components).unwrap()
        return DailyWorkTime(day: date, workTimes: workTimes)
    }
}

// MARK: -


private class WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {}
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
