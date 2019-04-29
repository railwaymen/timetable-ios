//
//  WorkTimesViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesViewModelTests: XCTestCase {
    private var userInterfaceMock: WorkTimesViewControllerMock!
    private var coordinatorMock: WorkTimesCoordinatorMock!
    private var contentProvider: WorkTimesContentProviderMock!
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
        userInterfaceMock = WorkTimesViewControllerMock()
        coordinatorMock = WorkTimesCoordinatorMock()
        errorHandlerMock = ErrorHandlerMock()
        contentProvider = WorkTimesContentProviderMock()
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

    func testViewWillAppearRunsFetchWorkTimesCallUpdateViewOnUserInterface() throws {
        //Arrange
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
    
    func testViewRequestedForPreviousMonthWhileSelectedMonthIsNilValue() {
        //Act
        let viewModel = buildViewModel(isSelecteDate: false)
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.duration)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.shouldWorkHours)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.workedHours)
    }
    
    func testViewRequestedForPreviousMonthWhileSelectedMonth() throws {
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
    
    func testViewRequestedForNextMonthWhileSelectedMonthIsNilValue() {
        //Act
        let viewModel = buildViewModel(isSelecteDate: false)
        viewModel.viewRequestForPreviousMonth()
        //Assert
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.duration)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.shouldWorkHours)
        XCTAssertNil(userInterfaceMock.updateMatchingFullTimeLabelsData.workedHours)
    }
    
    func testViewRequestedForNextMonthWhileSelectedMonth() throws {
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
    
    func testViewRequestedForCellModelOnInitialization() {
        //Arrange
        let viewModel = buildViewModel()
        let mockedCell = WorkTimeCellViewMock()
        //Act
        let cellViewModel = viewModel.viewRequestForCellModel(at: IndexPath(row: 0, section: 0), cell: mockedCell)
        //Assert
        XCTAssertNil(cellViewModel)
    }
    
    func testViewRequestedForCellModelAfterFetchingWorkTimes() throws {
        //Arrange
        let mockedCell = WorkTimeCellViewMock()
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
        let cellViewModel = viewModel.viewRequestForCellModel(at: IndexPath(row: 0, section: 0), cell: mockedCell)
        //Assert
        XCTAssertNotNil(cellViewModel)
    }
    
    func testViewRequestedForHeaderModelOnInitialization() {
        //Arrange
        let viewModel = buildViewModel()
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        //Act
        let headerViewModel = viewModel.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNil(headerViewModel)
    }
    
    func testViewRequestedForHeaderModelAfterFetchingWorkTimes() throws {
        //Arrange
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
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
        let headerViewModel = viewModel.viewRequestForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNotNil(headerViewModel)
    }

    func testViewRequestedForCellTypeBeforeViewWillAppear() {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let viewModel = buildViewModel()
        //Act
        let type = viewModel.viewRequestForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .standard)
    }
    
    func testViewRequestedForCellType() throws {
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
    
    func testViewRequestedForNewWorkTimeView() {
        //Arrange
        let button = UIButton()
        let viewModel = buildViewModel()
        //Act
        viewModel.viewRequestForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertEqual(coordinatorMock.requestedForNewWorkTimeViewSourceView, button)
    }
    
    private func buildViewModel(isSelecteDate: Bool = true) -> WorkTimesViewModel {
        let components = DateComponents(year: 2019, month: 2, day: 2)
        calendarMock.dateComponentsReturnValue = components
        if isSelecteDate {
            calendarMock.dateFromComponentsValue = Calendar.current.date(from: components)
        }
        return WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           contentProvider: contentProvider, errorHandler: errorHandlerMock, calendar: calendarMock)
    }
}

private class WorkTimeCellViewMock: WorkTimeCellViewModelOutput {
    func updateView(durationText: String?, bodyText: String?, taskUrlText: String?, fromToDateText: String?, projectTitle: String?, projectColor: UIColor?) {}
}

private class WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {}
}
