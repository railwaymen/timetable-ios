//
//  WorkTimeViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable type_body_length
// swiftlint:disable file_length
class WorkTimeViewModelTests: XCTestCase {
    private let timeout = TimeInterval(0.1)
    private var userInterface: WorkTimeViewControllerMock!
    private var apiClient: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var viewModel: WorkTimeViewModel!
    
    private enum ProjectsRecordsResponse: String, JSONFileResource {
        case simpleProjectArrayResponse
    }
    
    private let decoder = JSONDecoder()
    
    override func setUp() {
        userInterface = WorkTimeViewControllerMock()
        apiClient = ApiClientMock()
        errorHandlerMock = ErrorHandlerMock()
        calendarMock = CalendarMock()
        viewModel = WorkTimeViewModel(userInterface: userInterface, apiClient: apiClient, errorHandler: errorHandlerMock, calendar: calendarMock)
        super.setUp()
    }
    
    func testViewDidLoadSetUpUserInterfaceWithCurrentSelectedProject() throws {
        //Arrange
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(userInterface.setUpCurrentProjectName.currentProjectName, "Select project")
        XCTAssertTrue(try userInterface.setUpCurrentProjectName.allowsTask.unwrap())
    }
    
    func testViewDidLoadFetchSimpleListCallsErrorHandlerOnFetchFailure() throws {
        //Arrange
        let expectation = self.expectation(description: "")
        apiClient.fetchSimpleListOfProjectsExpectation = expectation.fulfill
        let error = ApiClientError(type: .invalidParameters)
        //Act
        viewModel.viewDidLoad()
        apiClient.fetchSimpleListOfProjectsCompletion?(.failure(error))
        waitForExpectations(timeout: timeout)
        //Assert
        let throwedError = try (errorHandlerMock.throwedError as? ApiClientError).unwrap()
        XCTAssertEqual(throwedError, error)
    }
    
    func testViewDidLoadFetchSimpleListCallsReloadProjectPickerOnTheUserInterface() throws {
        //Arrange
        let expectation = self.expectation(description: "")
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode([ProjectDecoder].self, from: data)
        apiClient.fetchSimpleListOfProjectsExpectation = expectation.fulfill
        //Act
        viewModel.viewDidLoad()
        apiClient.fetchSimpleListOfProjectsCompletion?(.success(projectDecoders))
        waitForExpectations(timeout: timeout)
        //Assert
        XCTAssertTrue(userInterface.reloadProjectPickerCalled)
    }
    
    func testViewRequestedForNumberOfProjectsWithoutFetchingProjectList() {
        //Act
        let number = viewModel.viewRequestedForNumberOfProjects()
        //Assert
        XCTAssertEqual(number, 0)
    }
    
    func testViewRequestedForNumberOfProjectsAfterSucceedFetchingProjectList() throws {
        //Arrange
        try fetchProjects()
        //Act
        let number = viewModel.viewRequestedForNumberOfProjects()
        //Assert
        XCTAssertEqual(number, 4)
    }
    
    func testViewRequestedForProjectTitleAtFirstRowBeforViewDidLaod() {
        //Act
        let title = viewModel.viewRequestedForProjectTitle(atRow: 0)
        //Assert
        XCTAssertNil(title)
    }
    
    func testViewRequestedForProjectTitleAtFirstRowAfterFetchingProjectsList() throws {
        //Arrange
        try fetchProjects()
        //Act
        let title = viewModel.viewRequestedForProjectTitle(atRow: 0)
        //Assert
        XCTAssertEqual(title, "asdsa")
    }
    
    func testSetDefaultTaskWhileProjectListIsEmpty() {
        //Act
        viewModel.setDefaultTask()
        //Assert
        XCTAssertNil(userInterface.setUpCurrentProjectName.allowsTask)
        XCTAssertNil(userInterface.setUpCurrentProjectName.currentProjectName)
    }
    
    func testSetDefaultTaskWhileProjectAfterFetchingProjectsListAndProjectNotSelected() throws {
        //Arrange
        try fetchProjects()
        //Act
        viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try userInterface.setUpCurrentProjectName.allowsTask.unwrap())
        XCTAssertEqual(try userInterface.setUpCurrentProjectName.currentProjectName.unwrap(), "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskWasSetPreviously() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        //Act
        viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try userInterface.setUpCurrentProjectName.allowsTask.unwrap())
        XCTAssertNotEqual(try userInterface.setUpCurrentProjectName.currentProjectName.unwrap(), "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskIsFullDayOption() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 3)
        //Act
        viewModel.setDefaultTask()
        //Assert
        XCTAssertNotNil(userInterface.updateFromDateValues.date)
        XCTAssertNotNil(userInterface.updateFromDateValues.dateString)
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertNotNil(userInterface.setMinimumDateForTypeToDateValues.minDate)
        XCTAssertNotNil(userInterface.updateToDateValues.date)
        XCTAssertNotNil(userInterface.updateToDateValues.dateString)
        XCTAssertTrue(userInterface.updateTimeLabelValues.called)
        XCTAssertNotNil(userInterface.updateTimeLabelValues.title)
    }
    
    func testViewSelectedProjectBeforeViewDidLoad() {
        //Act
        viewModel.viewSelectedProject(atRow: 0)
        //Assert
        XCTAssertNil(userInterface.setUpCurrentProjectName.allowsTask)
        XCTAssertNil(userInterface.setUpCurrentProjectName.currentProjectName)
    }
    
    func testViewSelectedProjectAfterFetchingProjectList() throws {
        //Arrange
        try fetchProjects()
        //Act
        viewModel.viewSelectedProject(atRow: 2)
        //Assert
        XCTAssertFalse(try userInterface.setUpCurrentProjectName.allowsTask.unwrap())
        XCTAssertNotEqual(try userInterface.setUpCurrentProjectName.currentProjectName.unwrap(), "asdsa")
    }
    
    func testViewRequestedToFinish() {
        //Act
        viewModel.viewRequestedToFinish()
        //Assert
        XCTAssertTrue(userInterface.dismissViewCalled)
    }
    
    func testViewRequestedToSaveWhileProjectIsNil() {
        //Arrange
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.projectTextField)
        default: XCTFail()
        }
    }

    func testViewRequestedToSaveWhileTaskBodySetAsNilValue() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 0)
        //Act
        viewModel.taskNameDidChange(value: nil)
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.taskTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskBodyIsNil() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 0)
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.taskTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsNil() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        viewModel.taskNameDidChange(value: "body")
        //Act
        viewModel.taskURLDidChange(value: nil)
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.taskURLTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsInvalidURL() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        viewModel.taskNameDidChange(value: "body")
        //Act
        viewModel.taskURLDidChange(value: "\\INVALID//")
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.taskURLTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskURLIsNil() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        viewModel.taskNameDidChange(value: "body")
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.taskURLTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskFromDateIsNil() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 0)
        viewModel.taskNameDidChange(value: "body")
        viewModel.taskURLDidChange(value: "www.example.com")
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.startsAtTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskToDateIsNil() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 0)
        viewModel.taskNameDidChange(value: "body")
        viewModel.taskURLDidChange(value: "www.example.com")
        viewModel.viewChanged(fromDate: fromDate)
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.endsAtTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskFromDateIsGreaterThanToDate() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 0)
        viewModel.taskNameDidChange(value: "body")
        viewModel.taskURLDidChange(value: "www.example.com")
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(fromDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(toDate: toDate)
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .timeGreaterThan?: break
        default: XCTFail()
        }
    }
    
    func testViewChangedFromDateUpdatesUpdateFromDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        viewModel.viewChanged(fromDate: fromDate)
        //Assert
        XCTAssertEqual(userInterface.updateFromDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateFromDateValues.dateString, "12:02 PM")
    }
    
    func testViewChangedFromDateUpdatesSetsMinimumDateForTypeToDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        viewModel.viewChanged(fromDate: fromDate)
        //Assert
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
    }
    
    func testViewChangedFromDateUpdatesUpdatesTimeLabelOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        //Act
        viewModel.viewChanged(fromDate: fromDate)
        //Assert
        XCTAssertTrue(userInterface.updateTimeLabelValues.called)
        XCTAssertEqual(userInterface.updateTimeLabelValues.title, "00:00 1/17/18")
    }
    
    func testViewChangedFromDateWhileToDateWasSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(toDate: toDate)
        calendarMock.dateBySettingReturnValue = fromDate
        //Act
        viewModel.viewChanged(fromDate: fromDate)
        //Assert
        XCTAssertTrue(userInterface.updateTimeLabelValues.called)
        XCTAssertEqual(userInterface.updateTimeLabelValues.title, "0m 1/17/18")
        
        XCTAssertEqual(userInterface.updateToDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateToDateValues.dateString, "12:02 PM")
    }
    
    func testSetDefaultFromDateWhileFromDateWasNotSet() {
        //Act
        viewModel.setDefaultFromDate()
        //Assert
        XCTAssertNotNil(userInterface.updateFromDateValues.date)
        XCTAssertNotNil(userInterface.updateFromDateValues.dateString)
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertNotNil(userInterface.setMinimumDateForTypeToDateValues.minDate)
        XCTAssertTrue(userInterface.updateTimeLabelValues.called)
        XCTAssertNotNil(userInterface.updateTimeLabelValues.title)
    }
    
    func testSetDefaultFromDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(fromDate: fromDate)
        //Act
        viewModel.setDefaultFromDate()
        //Assert
        XCTAssertEqual(userInterface.updateFromDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateFromDateValues.dateString, "12:02 PM")
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
        XCTAssertTrue(userInterface.updateTimeLabelValues.called)
        XCTAssertEqual(userInterface.updateTimeLabelValues.title, "00:00 1/17/18")
    }
    
    func testViewChangedToDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        //Act
        viewModel.viewChanged(toDate: toDate)
        //Assert
        XCTAssertEqual(userInterface.updateToDateValues.date, toDate)
        XCTAssertEqual(userInterface.updateToDateValues.dateString, "12:02 PM")
        XCTAssertFalse(userInterface.updateTimeLabelValues.called)
    }
    
    func testViewChangedToDateWhileFromDateSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 13
        let toDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(fromDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        //Act
        viewModel.viewChanged(toDate: toDate)
        //Assert
        XCTAssertEqual(userInterface.updateToDateValues.date, toDate)
        XCTAssertEqual(userInterface.updateToDateValues.dateString, "1:02 PM")
        XCTAssertTrue(userInterface.updateTimeLabelValues.called)
        XCTAssertEqual(userInterface.updateTimeLabelValues.title, "1h 1/17/18")
    }
    
    func testSetDefaultToDate() {
        //Act
        viewModel.setDefaultToDate()
        //Assert
        XCTAssertNotNil(userInterface.updateToDateValues.date)
        XCTAssertNotNil(userInterface.updateToDateValues.dateString)
        XCTAssertFalse(userInterface.updateTimeLabelValues.called)
    }
    
    func testSetDefaultToDateWhileToDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(toDate: toDate)
        //Act
        viewModel.setDefaultToDate()
        //Assert
        XCTAssertEqual(userInterface.updateToDateValues.date, toDate)
        XCTAssertEqual(userInterface.updateToDateValues.dateString, "12:02 PM")
        XCTAssertFalse(userInterface.updateTimeLabelValues.called)
        XCTAssertNil(userInterface.updateTimeLabelValues.title)
    }
    
    func testSetDefaultToDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(fromDate: fromDate)
        //Act
        viewModel.setDefaultToDate()
        //Assert
        XCTAssertEqual(userInterface.updateFromDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateFromDateValues.dateString, "12:02 PM")
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
        XCTAssertTrue(userInterface.updateTimeLabelValues.called)
        XCTAssertEqual(userInterface.updateTimeLabelValues.title, "0m 1/17/18")
    }
    
    func testViewRequestedToSaveAplClientThrowsError() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 13
        let toDate = try Calendar.current.date(from: components).unwrap()
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 0)
        viewModel.taskNameDidChange(value: "body")
        viewModel.taskURLDidChange(value: "www.example.com")
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(fromDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(toDate: toDate)
        //Act
        viewModel.viewRequestedToSave()
        apiClient.addWorkTimeComletion?(.failure(error))
        //Assert
        switch (errorHandlerMock.throwedError as? ApiClientError)?.type {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveAplClientSucceed() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 13
        let toDate = try Calendar.current.date(from: components).unwrap()
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 0)
        viewModel.taskNameDidChange(value: "body")
        viewModel.taskURLDidChange(value: "www.example.com")
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(fromDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(toDate: toDate)
        //Act
        viewModel.viewRequestedToSave()
        apiClient.addWorkTimeComletion?(.success(Void()))
        //Assert
        XCTAssertTrue(userInterface.dismissViewCalled)
    }
    
    func testViewHasBeenTappedCallsDismissKeyboardOnTheUserInterface() {
        //Act
        viewModel.viewHasBeenTapped()
        //Assert
        XCTAssertTrue(userInterface.dissmissKeyboardCalled)
    }
    
    // MARK: - Private
    private func fetchProjects() throws {
        let expectation = self.expectation(description: "")
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode([ProjectDecoder].self, from: data)
        apiClient.fetchSimpleListOfProjectsExpectation = expectation.fulfill
        viewModel.viewDidLoad()
        apiClient.fetchSimpleListOfProjectsCompletion?(.success(projectDecoders))
        waitForExpectations(timeout: timeout)
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
