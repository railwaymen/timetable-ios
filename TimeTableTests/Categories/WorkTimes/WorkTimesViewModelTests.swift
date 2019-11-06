//
//  WorkTimesViewModelTests.swift
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
        userInterfaceMock = WorkTimesListViewControllerMock()
        coordinatorMock = WorkTimesListCoordinatorMock()
        errorHandlerMock = ErrorHandlerMock()
        contentProvider = WorkTimesListContentProviderMock()
        calendarMock = CalendarMock()
        super.setUp()
    }
    
    func testNumberOfSectionsOnInitialization() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        let sections = viewModel.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 0)
    }
    
    func testNumberOfSectionsAfterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let sections = viewModel.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 1)
    }
    
    func testNumberOfRowsInSectionOnInitialization() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        let rows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 0)
    }
    
    func testNumberOfRowsInSectionAfterFetchingWorkTimes() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let rows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 2)
    }
    
    func testViewDidLoad() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterfaceMock.setUpViewCalled)
    }
    
    func testViewWillAppearFetchWorkTimesShowsActivityIndicatorBeforeFetch() throws {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertFalse(try userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewWillAppearFetchWorkTimesHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let matchingFullTime = try buildMatchingFullTimeDecoder()
        let dailyWorkTime = try buildDailyWorkTime()
        let viewModel = buildViewModel()
        //Act
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Assert
        XCTAssertTrue(try userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewWillAppearFetchWorkTimesHidesActivityIndicatorAfterFailedFetch() throws {
        //Arrange
        let error = TestError(message: "Error")
        let viewModel = buildViewModel()
        //Act
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.failure(error))
        //Assert
        XCTAssertTrue(try userInterfaceMock.setActivityIndicatorIsHidden.unwrap())
    }

    func testViewWillAppearRunsFetchWorkTimesCallUpdateViewOnUserInterface() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertTrue(userInterfaceMock.updateViewCalled)
    }
    
    func testViewWillAppearRunsFetchWorkTimesFinishWithError() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.failure(expectedError))
        //Act
        viewModel.viewWillAppear()
        //Assert
        let error = try (errorHandlerMock.throwedError as? TestError).unwrap()
        XCTAssertEqual(error, expectedError)
    }
    
    func testViewRequestForPreviousMonthWhileSelectedMonthIsNilValue() {
        //Act
        let viewModel = buildViewModel(isSelecteDate: false)
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.duration)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.shouldWorkHours)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.workedHours)
    }
    
    func testViewRequestForPreviousMonthWhileSelectedMonth() throws {
        //Arrange
        let viewModel = buildViewModel()
        let components = DateComponents(year: 2019, month: 1, day: 1)
        let date = Calendar.current.date(from: components)
        calendarMock.shortDateByAddingReturnValue = date
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2019, month: 1)
        //Act
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertEqual(userInterfaceMock.updateDateSelectorData.currentDateString, "Jan 2019")
        XCTAssertEqual(userInterfaceMock.updateDateSelectorData.nextDateString, "Jan 2019")
        XCTAssertEqual(userInterfaceMock.updateDateSelectorData.previousDateString, "Jan 2019")
    }
    
    func testViewRequestForNextMonthWhileSelectedMonthIsNilValue() {
        //Act
        let viewModel = buildViewModel(isSelecteDate: false)
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.duration)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.shouldWorkHours)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.workedHours)
    }
    
    func testViewRequestForNextMonthWhileSelectedMonth() throws {
        //Arrange
        let viewModel = buildViewModel()
        let components = DateComponents(year: 2019, month: 1, day: 1)
        let date = Calendar.current.date(from: components)
        calendarMock.shortDateByAddingReturnValue = date
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2019, month: 3)
        //Act
        viewModel.viewRequestForNextMonth()
        //Assert
        XCTAssertEqual(userInterfaceMock.updateDateSelectorData.currentDateString, "Mar 2019")
        XCTAssertEqual(userInterfaceMock.updateDateSelectorData.nextDateString, "Mar 2019")
        XCTAssertEqual(userInterfaceMock.updateDateSelectorData.previousDateString, "Mar 2019")
    }
    
    func testViewRequestForCellModelOnInitialization() {
        //Arrange
        let viewModel = buildViewModel()
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
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let cellViewModel = viewModel.viewRequestForCellModel(at: IndexPath(row: 0, section: 0), cell: mockedCell)
        //Assert
        XCTAssertNotNil(cellViewModel)
    }
    
    func testViewRequestForHeaderModelOnInitialization() {
        //Arrange
        let viewModel = buildViewModel()
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
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let headerViewModel = viewModel.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNotNil(headerViewModel)
    }
    
    func testViewRequestToDeleteWorkTime_invalidIndexPath() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        viewModel.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            //Assert
            XCTAssertFalse(completed)
        }
    }
    
    func testViewRequestToDeleteWorkTime_errorResponse() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            //Assert
            XCTAssertFalse(completed)
        }
        contentProvider.deleteWorkTimeCompletion?(.failure(expectedError))
    }
    
    func testViewRequestToDeleteWorkTime_succeed() throws {
        //Arrange
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestToDelete(at: IndexPath(row: 0, section: 0)) { completed in
            //Assert
            XCTAssertTrue(completed)
        }
        contentProvider.deleteWorkTimeCompletion?(.success(Void()))
    }

    func testViewRequestForCellTypeBeforeViewWillAppear() {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let viewModel = buildViewModel()
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
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        let type = viewModel.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .taskURL)
    }
    
    func testViewRequestForNewWorkTimeView() {
        //Arrange
        let button = UIButton()
        let viewModel = buildViewModel()
        //Act
        viewModel.viewRequestForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertEqual(coordinatorMock.workTimesRequestedForNewWorkTimeViewSourceView, button)
    }
    
    func testViewRequestedForEditEntry_withoutDailyWorkTimes() {
        //Arrange
        let cell = UITableViewCell()
        let viewModel = buildViewModel()
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        viewModel.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
        //Assert
        XCTAssertNil(coordinatorMock.workTimesRequestedForEditWorkTimeViewData)
    }
    
    func testViewRequestedForEditEntry_withDailyWorkTimes() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = UITableViewCell()
        let matchingFullTime = try self.buildMatchingFullTimeDecoder()
        let dailyWorkTime = try self.buildDailyWorkTime()
        let workTime = try dailyWorkTime.workTimes.first.unwrap()
        let viewModel = buildViewModel()
        viewModel.viewWillAppear()
        contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestedForEditEntry(sourceView: cell, at: indexPath)
        //Assert
        let returnedData = try coordinatorMock.workTimesRequestedForEditWorkTimeViewData.unwrap()
        XCTAssertEqual(returnedData.sourceView, cell)
        XCTAssertEqual(returnedData.editedTask.workTimeIdentifier, workTime.identifier)
        XCTAssertEqual(returnedData.editedTask.project, workTime.project)
        XCTAssertEqual(returnedData.editedTask.body, workTime.body)
        XCTAssertEqual(returnedData.editedTask.url?.absoluteString, workTime.task)
        XCTAssertEqual(returnedData.editedTask.day, dailyWorkTime.day)
        XCTAssertEqual(returnedData.editedTask.startAt, workTime.startsAt)
        XCTAssertEqual(returnedData.editedTask.endAt, workTime.endsAt)
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
        viewModel.viewWillAppear()
        self.contentProvider.fetchWorkTimesDataCompletion?(.success(([dailyWorkTime], matchingFullTime)))
        //Act
        viewModel.viewRequestToDuplicate(sourceView: cell, at: indexPath)
        //Assert
        let returnedData = try self.coordinatorMock.workTimesRequestedForDuplicateWorkTimeViewData.unwrap()
        XCTAssertEqual(returnedData.sourceView, cell)
        XCTAssertEqual(returnedData.duplicatedTask.workTimeIdentifier, duplicatedWorkTime.identifier)
        XCTAssertEqual(returnedData.duplicatedTask.project, duplicatedWorkTime.project)
        XCTAssertEqual(returnedData.duplicatedTask.body, duplicatedWorkTime.body)
        XCTAssertEqual(returnedData.duplicatedTask.url?.absoluteString, duplicatedWorkTime.task)
        XCTAssertEqual(returnedData.duplicatedTask.day, dailyWorkTime.day)
        XCTAssertEqual(returnedData.duplicatedTask.startAt, duplicatedWorkTime.startsAt)
        XCTAssertEqual(returnedData.duplicatedTask.endAt, duplicatedWorkTime.endsAt)
        
        XCTAssertEqual(returnedData.lastTask?.workTimeIdentifier, firstWorkTime.identifier)
        XCTAssertEqual(returnedData.lastTask?.project, firstWorkTime.project)
        XCTAssertEqual(returnedData.lastTask?.body, firstWorkTime.body)
        XCTAssertEqual(returnedData.lastTask?.url?.absoluteString, firstWorkTime.task)
        XCTAssertEqual(returnedData.lastTask?.day, dailyWorkTime.day)
        XCTAssertEqual(returnedData.lastTask?.startAt, firstWorkTime.startsAt)
        XCTAssertEqual(returnedData.lastTask?.endAt, firstWorkTime.endsAt)
    }
    
    // MARK: - Private
    private func buildViewModel(isSelecteDate: Bool = true) -> WorkTimesListViewModel {
        let components = DateComponents(year: 2019, month: 2, day: 2)
        calendarMock.dateComponentsReturnValue = components
        if isSelecteDate {
            calendarMock.dateFromComponentsValue = Calendar.current.date(from: components)
        }
        return WorkTimesListViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                  contentProvider: contentProvider, errorHandler: errorHandlerMock, calendar: calendarMock)
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
private class WorkTimeCellViewMock: WorkTimeCellViewModelOutput {
    func setUp() {}
    
    func updateView(data: WorkTimeCellViewModel.ViewData) {}
}

private class WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {}
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
