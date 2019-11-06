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
        viewModel = self.createViewModel(flowType: .newEntry(lastTask: nil))
        super.setUp()
    }
    
    func testViewDidLoadSetUpUserInterfaceWithCurrentSelectedProject() throws {
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertNotNil(userInterface.updateDayValues.date)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.currentProjectName, "Select project")
        XCTAssertTrue(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
    }
    
    func testViewDidLoadWithLastTaskSetsDateAndTime() throws {
        //Arrange
        let lastTask = try createTask(workTimeIdentifier: nil)
        viewModel = createViewModel(flowType: .newEntry(lastTask: lastTask))
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try userInterface.updateDayValues.date.unwrap()))
        XCTAssertEqual(userInterface.updateStartAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(userInterface.updateEndAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.currentProjectName, "Select project")
        XCTAssertTrue(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
    }
    
    func testViewDidLoad_withEditedTask() throws {
        //Arrange
        let task = try createTask(workTimeIdentifier: 123)
        viewModel = createViewModel(flowType: .editEntry(editedTask: task))
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(userInterface.updateDayValues.date, task.day)
        XCTAssertEqual(userInterface.updateStartAtDateValues.date, task.startAt)
        XCTAssertEqual(userInterface.updateEndAtDateValues.date, task.endAt)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.currentProjectName, task.project?.name)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.body, task.body)
        XCTAssertNotNil(userInterface.setUpCurrentProjectName?.urlString)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithoutLastTask() throws {
        //Arrange
        let task = try createTask(workTimeIdentifier: 123)
        viewModel = createViewModel(flowType: .duplicateEntry(duplicatedTask: task, lastTask: nil))
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertNotEqual(userInterface.updateDayValues.date, task.day)
        XCTAssertNotEqual(userInterface.updateStartAtDateValues.date, task.startAt)
        XCTAssertNotEqual(userInterface.updateEndAtDateValues.date, task.endAt)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.currentProjectName, task.project?.name)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.body, task.body)
        XCTAssertNotNil(userInterface.setUpCurrentProjectName?.urlString)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithLastTask() throws {
        //Arrange
        let task = try createTask(workTimeIdentifier: 123, index: 3)
        let lastTask = try createTask(workTimeIdentifier: 12, index: 2)
        viewModel = createViewModel(flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask))
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try userInterface.updateDayValues.date.unwrap()))
        XCTAssertEqual(userInterface.updateStartAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(userInterface.updateEndAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.currentProjectName, task.project?.name)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.body, task.body)
        XCTAssertNotNil(userInterface.setUpCurrentProjectName?.urlString)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoadFetchSimpleListShowsActivityIndicatorBeforeFetch() throws {
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        //Act
        viewModel.viewDidLoad()
        apiClient.fetchSimpleListOfProjectsCompletion?(.success(projectDecoders))
        //Assert
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterFailedFetch() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        //Act
        viewModel.viewDidLoad()
        apiClient.fetchSimpleListOfProjectsCompletion?(.failure(error))
        //Assert
        XCTAssertTrue(try userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchSimpleListCallsErrorHandlerOnFetchFailure() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        //Act
        viewModel.viewDidLoad()
        apiClient.fetchSimpleListOfProjectsCompletion?(.failure(error))
        //Assert
        let throwedError = try (errorHandlerMock.throwedError as? ApiClientError).unwrap()
        XCTAssertEqual(throwedError, error)
    }
    
    func testViewDidLoadFetchSimpleListUpdatesUserInterface() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        //Act
        viewModel.viewDidLoad()
        apiClient.fetchSimpleListOfProjectsCompletion?(.success(projectDecoders))
        //Assert
        XCTAssertTrue(userInterface.reloadProjectPickerCalled)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.currentProjectName, "asdsa")
    }
    
    func testViewDidLoadFetchSimpleListWithLastTaskUpdatesUserInterface() throws {
        //Arrange
        let lastTask = try createTask(workTimeIdentifier: 2)
        calendarMock.isDateInTodayReturnValue = true
        viewModel = createViewModel(flowType: .newEntry(lastTask: lastTask))
        //Act
        try fetchProjects()
        //Assert
        XCTAssertTrue(userInterface.reloadProjectPickerCalled)
        XCTAssertNotNil(userInterface.setUpCurrentProjectName)
        XCTAssertEqual(userInterface.setUpCurrentProjectName?.currentProjectName, lastTask.project?.name)
    }
    
    func testViewSelectedProjectStartAtTime() throws {
        //Arrange
        try fetchProjects()
        //Act
        viewModel.viewSelectedProject(atRow: 0)
        //Assert
        XCTAssertNotNil(userInterface.updateStartAtDateValues.date)
    }
    
    func testViewSelectedProjectSetsEndAtTime() throws {
        //Arrange
        try fetchProjects()
        //Act
        viewModel.viewSelectedProject(atRow: 0)
        //Assert
        XCTAssertNotNil(userInterface.updateEndAtDateValues.date)
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
    
    func testViewRequestedForNumberOfTags() {
        //Arrange
        self.viewModel.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.success(simpleProjectDecoder))
        //Act
        let numberOfTags = self.viewModel.viewRequestedForNumberOfTags()
        //Assert
        XCTAssertEqual(numberOfTags, 1)
    }
    
    func testViewRequestedForTag() {
        //Arrange
        self.viewModel.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.success(simpleProjectDecoder))
        //Act
        let tag = self.viewModel.viewRequestedForTag(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(tag, .internalMeeting)
    }
    
    func testViewRequestedForTag_outOfBounds() {
        //Act
        let tag = self.viewModel.viewRequestedForTag(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertNil(tag)
    }
    
    func testViewSelectedTag() {
        //Arrange
        self.viewModel.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        self.viewModel.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertTrue(self.userInterface.reloadTagsViewCalled)
        XCTAssertTrue(self.viewModel.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_secondTime() {
        //Arrange
        self.viewModel.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        self.viewModel.viewSelectedTag(at: indexPath)
        self.viewModel.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertTrue(self.userInterface.reloadTagsViewCalled)
        XCTAssertFalse(self.viewModel.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_outOfBounds() {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        self.viewModel.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertFalse(self.userInterface.reloadTagsViewCalled)
        XCTAssertFalse(self.viewModel.isTagSelected(at: indexPath))
    }
    
    func testSetDefaultTaskWhileProjectListIsEmpty() {
        //Act
        viewModel.setDefaultTask()
        //Assert
        XCTAssertNil(userInterface.setUpCurrentProjectName?.allowsTask)
        XCTAssertNil(userInterface.setUpCurrentProjectName?.currentProjectName)
    }
    
    func testSetDefaultTaskWhileProjectAfterFetchingProjectsListAndProjectNotSelected() throws {
        //Arrange
        try fetchProjects()
        //Act
        viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
        XCTAssertEqual(try (userInterface.setUpCurrentProjectName?.currentProjectName).unwrap(), "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskWasSetPreviously() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        //Act
        viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
        XCTAssertNotEqual(try (userInterface.setUpCurrentProjectName?.currentProjectName).unwrap(), "asdsa")
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
        XCTAssertNil(userInterface.setUpCurrentProjectName?.allowsTask)
        XCTAssertNil(userInterface.setUpCurrentProjectName?.currentProjectName)
    }
    
    func testViewSelectedProjectAfterFetchingProjectList() throws {
        //Arrange
        try fetchProjects()
        //Act
        viewModel.viewSelectedProject(atRow: 2)
        //Assert
        XCTAssertFalse(try (userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
        XCTAssertNotEqual(try (userInterface.setUpCurrentProjectName?.currentProjectName).unwrap(), "asdsa")
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
        case .cannotBeEmptyOr(let element1, let element2)?:
            XCTAssertEqual(element1, UIElement.taskNameTextField)
            XCTAssertEqual(element2, UIElement.taskUrlTextField)
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
        case .cannotBeEmptyOr(let element1, let element2)?:
            XCTAssertEqual(element1, UIElement.taskNameTextField)
            XCTAssertEqual(element2, UIElement.taskUrlTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskBodyIsNilAndURLIsNot() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        viewModel.taskNameDidChange(value: nil)
        //Act
        viewModel.taskURLDidChange(value: "www.example.com")
        viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(errorHandlerMock.throwedError as? UIError)
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
        XCTAssertNil(errorHandlerMock.throwedError as? UIError)
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
        XCTAssertNil(errorHandlerMock.throwedError as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLIsNil() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        viewModel.taskNameDidChange(value: "body")
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(errorHandlerMock.throwedError as? UIError)
    }
    
    func testViewRequestedToSaveWhileProjectIsLunch() throws {
        //Arrange
        try fetchProjects()
        viewModel.viewSelectedProject(atRow: 1)
        //Act
        viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(errorHandlerMock.throwedError as? UIError)
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
        XCTAssertEqual(errorHandlerMock.throwedError as? UIError, .timeGreaterThan)
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
    
    func testViewRequestedToSaveApiClientThrowsError() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        try fetchProjects()
        let task = try createTask(workTimeIdentifier: nil)
        try fillAllDataInViewModel(task: task)
        //Act
        viewModel.viewRequestedToSave()
        apiClient.addWorkTimeComletion?(.failure(error))
        //Assert
        XCTAssertEqual((errorHandlerMock.throwedError as? ApiClientError)?.type, error.type)
    }
    
    func testViewRequestedToSaveApiClientSucceed() throws {
        //Arrange
        try fetchProjects()
        let task = try createTask(workTimeIdentifier: nil)
        try fillAllDataInViewModel(task: task)
        //Act
        viewModel.viewRequestedToSave()
        apiClient.addWorkTimeComletion?(.success(Void()))
        //Assert
        XCTAssertTrue(userInterface.dismissViewCalled)
    }
    
    func testViewRequestedToSaveApiClient_updatesExistingWorkItem() throws {
        //Arrange
        try fetchProjects()
        let task = try createTask(workTimeIdentifier: 1)
        viewModel = createViewModel(flowType: .editEntry(editedTask: task))
        try fillAllDataInViewModel(task: task)
        //Act
        viewModel.viewRequestedToSave()
        apiClient.updateWorkTimeCompletion?(.success(Void()))
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
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        viewModel.viewDidLoad()
        try apiClient.fetchSimpleListOfProjectsCompletion.unwrap()(.success(projectDecoders))
    }
    
    private func createViewModel(flowType: WorkTimeViewModel.FlowType) -> WorkTimeViewModel {
        return WorkTimeViewModel(userInterface: userInterface,
                                 coordinator: nil,
                                 apiClient: apiClient,
                                 errorHandler: errorHandlerMock,
                                 calendar: calendarMock,
                                 flowType: flowType)
    }
    
    private func createTask(workTimeIdentifier: Int64?, index: Int = 3) throws -> Task {
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let simpleProjectDecoder = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        let project = simpleProjectDecoder.projects[index]
        return Task(workTimeIdentifier: workTimeIdentifier,
                    project: project,
                    body: "Blah blah blah",
                    url: try URL(string: "http://example.com").unwrap(),
                    day: Date(),
                    startAt: try createTime(hours: 8, minutes: 0),
                    endAt: try createTime(hours: 9, minutes: 30),
                    tag: .default)
    }
    
    private func createTime(hours: Int, minutes: Int) throws -> Date {
        return try Calendar(identifier: .gregorian).date(bySettingHour: hours, minute: minutes, second: 0, of: Date()).unwrap()
    }
    
    private func fillAllDataInViewModel(task: Task) throws {
        let fromDate = try task.startAt.unwrap()
        let toDate = try task.endAt.unwrap()
        viewModel.viewChanged(day: try task.day.unwrap())
        calendarMock.dateBySettingReturnValue = fromDate
        viewModel.viewChanged(startAtDate: fromDate)
        calendarMock.dateBySettingReturnValue = toDate
        viewModel.viewChanged(endAtDate: toDate)
        viewModel.viewSelectedProject(atRow: 0)
        viewModel.taskNameDidChange(value: "body")
        viewModel.taskURLDidChange(value: "www.example.com")
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
