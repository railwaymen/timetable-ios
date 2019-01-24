//
//  WorkTimesViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable type_body_length
class WorkTimesViewModelTests: XCTestCase {
    private var userInterfaceMock: WorkTimesViewControllerMock!
    private var apiClientMock: ApiClientMock!
    private var coordinatorMock: WorkTimesCoordinatorMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var viewModel: WorkTimesViewModel!
    
    private enum WorkTimesResponse: String, JSONFileResource {
        case workTimesResponse
        case workTimesResponseNotSorted
    }
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    override func setUp() {
        userInterfaceMock = WorkTimesViewControllerMock()
        apiClientMock = ApiClientMock()
        coordinatorMock = WorkTimesCoordinatorMock()
        errorHandlerMock = ErrorHandlerMock()
        calendarMock = CalendarMock()
        viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                       apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        super.setUp()
    }
    
    func testNumberOfSectionsOnInitialization() {
        //Arrange
        //Act
        let sections = viewModel.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 0)
    }
    
    func testNumberOfSectionsAfterFetchingWorkTimes() throws {
        //Arrange
        //workTimesResponse
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        let sections = viewModel.numberOfSections()
        //Assert
        XCTAssertEqual(sections, 1)
    }
    
    func testNumberOfRowsInSectionOnInitialization() {
        //Arrange
        //Act
        let rows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 0)
    }
    
    func testNumberOfRowsInSectionAfterFetchingWorkTimes() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        let rows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(rows, 2)
    }
    
    func testViewDidLoad() {
        //Arrange
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterfaceMock.setUpViewCalled)
    }
    
    func testViewWillAppearRunsFetchWorkTimesWithNilDates() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewWillAppearRunsFetchWorkTimesWithNotNilFromDate() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        calendarMock.dateFromComponentsValue = Date()
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertNotNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewWillAppearRunsFetchWorkTimesWithNotNilDates() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        calendarMock.dateFromComponentsValue = Date()
        calendarMock.shortDateByAddingReturnValue = Date()
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertNotNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNotNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewWillAppearRunsFetchWorkTimesSortResponse() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponseNotSorted)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        calendarMock.dateFromComponentsValue = Date()
        calendarMock.shortDateByAddingReturnValue = Date()
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertNotNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNotNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewWillAppearRunsFetchWorkTimesCallUpdateViewOnUserInterface() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        calendarMock.dateFromComponentsValue = Date()
        calendarMock.shortDateByAddingReturnValue = Date()
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        viewModel.viewWillAppear()
        //Assert
        XCTAssertTrue(userInterfaceMock.updateViewCalled)
    }
    
    func testViewWillAppearRunsFetchWorkTimesFinishWithError() throws {
        //Arrange
        let expectedError = TestError(message: "Error")
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        calendarMock.dateFromComponentsValue = Date()
        calendarMock.shortDateByAddingReturnValue = Date()
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.failure(expectedError))
        //Act
        viewModel.viewWillAppear()
        //Assert
        let error = try (errorHandlerMock.throwedError as? TestError).unwrap()
        XCTAssertEqual(error, expectedError)
    }
    
    func testViewRequestedForCellModelOnInitialization() {
        //Arrange
        let mockedCell = WorkTimeCellViewMock()
        //Act
        let cellViewModel = viewModel.viewRequestedForCellModel(at: IndexPath(row: 0, section: 0), cell: mockedCell)
        //Assert
        XCTAssertNil(cellViewModel)
    }
    
    func testViewRequestedForCellModelAfterFetchingWorkTimes() throws {
        //Arrange
        let mockedCell = WorkTimeCellViewMock()
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        calendarMock.dateFromComponentsValue = Date()
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        let cellViewModel = viewModel.viewRequestedForCellModel(at: IndexPath(row: 0, section: 0), cell: mockedCell)
        //Assert
        XCTAssertNotNil(cellViewModel)
    }
    
    func testViewRequestedForHeaderModelOnInitialization() {
        //Arrange
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        //Act
        let headerViewModel = viewModel.viewRequestedForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNil(headerViewModel)
    }
    
    func testViewRequestedForHeaderModelAfterFetchingWorkTimes() throws {
        //Arrange
        let mockedHeader = WorkTimesTableViewHeaderViewMock()
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 11)
        calendarMock.dateFromComponentsValue = Date()
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        let headerViewModel = viewModel.viewRequestedForHeaderModel(at: 0, header: mockedHeader)
        //Assert
        XCTAssertNotNil(headerViewModel)
    }
    
    func testViewRequestedForPreviousMonthWhileSelectedMonthIsNil() {
        //Arrange
        //Act
        viewModel.viewRequestedForPreviousMonth()
        //Assert
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewRequestedForPreviousMonthWhileCalendarDateComonetsForMonthReturnedInvalidValue() {
        //Arrange
        calendarMock.dateFromComponentsValue = Date()
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018)
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        //Act
        viewModel.viewRequestedForPreviousMonth()
        //Assert
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewRequestedForPreviousMonthSucceed() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 12, day: 31)
        let date = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateFromComponentsValue = date
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 1)
        components.month = 11
        let dateByAddingReturnValue = try Calendar.current.date(from: components).unwrap()
        calendarMock.shortDateByAddingReturnValue = dateByAddingReturnValue
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        //Act
        viewModel.viewRequestedForPreviousMonth()
        //Assert
        XCTAssertNotNil(userInterfaceMock.updateDateSelectorData.currentDateString)
        XCTAssertNotNil(userInterfaceMock.updateDateSelectorData.nextDateString)
        XCTAssertNotNil(userInterfaceMock.updateDateSelectorData.previousDateString)
    }
    
    func testViewRequestedForNextMonthWhileSelectedMonthIsNil() {
        //Arrange
        //Act
        viewModel.viewRequestedForNextMonth()
        //Assert
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewRequestedForNextMonthWhileCalendarDateComonetsForMonthReturnedInvalidValue() {
        //Arrange
        calendarMock.dateFromComponentsValue = Date()
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018)
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        //Act
        viewModel.viewRequestedForPreviousMonth()
        //Assert
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewRequestedForNextMonthForLastMonth() {
        //Arrange
        calendarMock.dateFromComponentsValue = Date()
        calendarMock.dateComponentsReturnValue = DateComponents(month: 12)
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        //Act
        viewModel.viewRequestedForNextMonth()
        //Assert
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.fromDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.toDate)
        XCTAssertNil(apiClientMock.fetchWorkTimesParameters?.projectIdentifier)
    }
    
    func testViewRequestedForNextMonthSucceed() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 12, day: 31)
        let date = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateFromComponentsValue = date
        calendarMock.dateComponentsReturnValue = DateComponents(year: 2018, month: 12)
        components.month = 11
        let dateByAddingReturnValue = try Calendar.current.date(from: components).unwrap()
        calendarMock.shortDateByAddingReturnValue = dateByAddingReturnValue
        let viewModel = WorkTimesViewModel(userInterface: userInterfaceMock, coordinator: coordinatorMock,
                                           apiClient: apiClientMock, errorHandler: errorHandlerMock, calendar: calendarMock)
        //Act
        viewModel.viewRequestedForNextMonth()
        //Assert
        XCTAssertNotNil(userInterfaceMock.updateDateSelectorData.currentDateString)
        XCTAssertNotNil(userInterfaceMock.updateDateSelectorData.nextDateString)
        XCTAssertNotNil(userInterfaceMock.updateDateSelectorData.previousDateString)
    }
    
    func testViewRequestedForCellTypeBeforeViewWillAppear() {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        let type = viewModel.viewRequestedForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .standard)
    }
    
    func testViewRequestedForCellType() throws {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        viewModel.viewWillAppear()
        apiClientMock.fetchWorkTimesCompletion?(.success(workTimes))
        //Act
        let type = viewModel.viewRequestedForCellType(at: indexPath)
        //Assert
        XCTAssertEqual(type, .taskURL)
    }
    
    func testViewRequestedForNewWorkTimeView() {
        //Arrange
        let button = UIButton()
        //Act
        viewModel.viewRequestedForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertEqual(coordinatorMock.requestedForNewWorkTimeViewSourceView, button)
    }
}

private class WorkTimeCellViewMock: WorkTimeCellViewModelOutput {
    func updateView(durationText: String?, bodyText: String?, taskUrlText: String?, fromToDateText: String?, projectTitle: String?, projectColor: UIColor?) {}
}

private class WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {}
}
// swiftlint:enabled type_body_length
