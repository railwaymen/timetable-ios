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
        XCTAssertNotNil(userInterface.updateStartAtDateValues.date)
        XCTAssertNotNil(userInterface.updateStartAtDateValues.dateString)
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertNotNil(userInterface.setMinimumDateForTypeToDateValues.minDate)
        XCTAssertNotNil(userInterface.updateEndAtDateValues.date)
        XCTAssertNotNil(userInterface.updateEndAtDateValues.dateString)
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
        viewModel.viewChanged(startAtDate: fromDate)
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
        viewModel.viewChanged(startAtDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(endAtDate: toDate)
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        switch errorHandlerMock.throwedError as? UIError {
        case .timeGreaterThan?: break
        default: XCTFail()
        }
    }
    
    func testSetDefaultDayIfDayWasNotSet() {
        //Act
        viewModel.setDefaultDay()
        //Assert
        XCTAssertNotNil(userInterface.updateDayValues.date)
        XCTAssertNotNil(userInterface.updateDayValues.dateString)
    }
    
    func testSetDefaultDayNotSetCurrentDayIfWasSetBefore() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17)
        let day = try Calendar.current.date(from: components).unwrap()
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        viewModel.viewChanged(day: day)
        //Act
        viewModel.setDefaultDay()
        //Assert
        XCTAssertEqual(userInterface.updateDayValues.date, day)
        XCTAssertEqual(userInterface.updateDayValues.dateString, dayString)
    }
    
    func testViewChangedDay() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17)
        let day = try Calendar.current.date(from: components).unwrap()
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        //Act
        viewModel.viewChanged(day: day)
        //Assert
        XCTAssertEqual(userInterface.updateDayValues.date, day)
        XCTAssertEqual(userInterface.updateDayValues.dateString, dayString)
    }
    
    func testViewChangedFromDateUpdatesUpdateFromDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(userInterface.updateStartAtDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateStartAtDateValues.dateString, "12:02 PM")
    }
    
    func testViewChangedFromDateUpdatesSetsMinimumDateForTypeToDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
    }
    
    func testViewChangedFromDateWhileToDateWasSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(endAtDate: toDate)
        calendarMock.dateBySettingReturnValue = fromDate
        //Act
        viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(userInterface.updateEndAtDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateEndAtDateValues.dateString, "12:02 PM")
    }
    
    func testSetDefaultFromDateWhileFromDateWasNotSet() {
        //Act
        viewModel.setDefaultStartAtDate()
        //Assert
        XCTAssertNotNil(userInterface.updateStartAtDateValues.date)
        XCTAssertNotNil(userInterface.updateStartAtDateValues.dateString)
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertNotNil(userInterface.setMinimumDateForTypeToDateValues.minDate)
    }
    
    func testSetDefaultFromDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(startAtDate: fromDate)
        //Act
        viewModel.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(userInterface.updateStartAtDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateStartAtDateValues.dateString, "12:02 PM")
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
    }
    
    func testViewChangedToDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        //Act
        viewModel.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(userInterface.updateEndAtDateValues.date, toDate)
        XCTAssertEqual(userInterface.updateEndAtDateValues.dateString, "12:02 PM")
    }
    
    func testViewChangedToDateWhileFromDateSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 13
        let toDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(startAtDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        //Act
        viewModel.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(userInterface.updateEndAtDateValues.date, toDate)
        XCTAssertEqual(userInterface.updateEndAtDateValues.dateString, "1:02 PM")
    }
    
    func testSetDefaultToDate() {
        //Act
        viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertNotNil(userInterface.updateEndAtDateValues.date)
        XCTAssertNotNil(userInterface.updateEndAtDateValues.dateString)
    }
    
    func testSetDefaultToDateWhileToDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(endAtDate: toDate)
        //Act
        viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(userInterface.updateEndAtDateValues.date, toDate)
        XCTAssertEqual(userInterface.updateEndAtDateValues.dateString, "12:02 PM")
    }
    
    func testSetDefaultToDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(startAtDate: fromDate)
        //Act
        viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(userInterface.updateStartAtDateValues.date, fromDate)
        XCTAssertEqual(userInterface.updateStartAtDateValues.dateString, "12:02 PM")
        XCTAssertTrue(userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
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
        viewModel.viewChanged(startAtDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(endAtDate: toDate)
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
        viewModel.viewChanged(startAtDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(endAtDate: toDate)
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
