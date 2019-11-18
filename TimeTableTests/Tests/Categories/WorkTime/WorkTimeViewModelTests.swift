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
    private var coordinatorMock: WorkTimeCoordinatorMock!
    private var apiClient: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var viewModel: WorkTimeViewModel!
    
    private enum ProjectsRecordsResponse: String, JSONFileResource {
        case simpleProjectArrayResponse
    }
    
    private let decoder = JSONDecoder()
    
    override func setUp() {
        self.userInterface = WorkTimeViewControllerMock()
        self.apiClient = ApiClientMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.calendarMock = CalendarMock()
        self.coordinatorMock = WorkTimeCoordinatorMock()
        self.viewModel = self.createViewModel(flowType: .newEntry(lastTask: nil))
        super.setUp()
    }
    
    func testViewDidLoadSetUpUserInterfaceWithCurrentSelectedProject() throws {
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.count, 1)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, "Select project")
        XCTAssertTrue(try (self.userInterface.setUpParams.last?.allowsTask).unwrap())
    }
    
    func testViewDidLoadWithLastTaskSetsDateAndTime() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: nil)
        self.viewModel = self.createViewModel(flowType: .newEntry(lastTask: lastTask))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try (self.userInterface.updateDayParams.last?.date).unwrap()))
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, "Select project")
        XCTAssertTrue(try (self.userInterface.setUpParams.last?.allowsTask).unwrap())
    }
    
    func testViewDidLoad_withEditedTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123)
        self.viewModel = self.createViewModel(flowType: .editEntry(editedTask: task))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.last?.date, task.day)
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, task.startAt)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, task.endAt)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterface.setUpParams.last?.body, task.body)
        XCTAssertNotNil(self.userInterface.setUpParams.last?.urlString)
        XCTAssertEqual(self.userInterface.setUpParams.last?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (self.userInterface.setUpParams.last?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithoutLastTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123)
        self.viewModel = self.createViewModel(flowType: .duplicateEntry(duplicatedTask: task, lastTask: nil))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertNotEqual(self.userInterface.updateDayParams.last?.date, task.day)
        XCTAssertNotEqual(self.userInterface.updateStartAtDateParams.last?.date, task.startAt)
        XCTAssertNotEqual(self.userInterface.updateEndAtDateParams.last?.date, task.endAt)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterface.setUpParams.last?.body, task.body)
        XCTAssertNotNil(self.userInterface.setUpParams.last?.urlString)
        XCTAssertEqual(self.userInterface.setUpParams.last?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (self.userInterface.setUpParams.last?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithLastTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123, index: 3)
        let lastTask = try self.createTask(workTimeIdentifier: 12, index: 2)
        self.viewModel = self.createViewModel(flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try (self.userInterface.updateDayParams.last?.date).unwrap()))
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterface.setUpParams.last?.body, task.body)
        XCTAssertNotNil(self.userInterface.setUpParams.last?.urlString)
        XCTAssertEqual(self.userInterface.setUpParams.last?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (self.userInterface.setUpParams.last?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoadFetchSimpleListShowsActivityIndicatorBeforeFetch() throws {
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(projectDecoders))
        //Assert
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterFailedFetch() {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.failure(error))
        //Assert
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewDidLoadFetchSimpleListCallsErrorHandlerOnFetchFailure() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.failure(error))
        //Assert
        let throwedError = try (self.errorHandlerMock.throwingParams.last?.error as? ApiClientError).unwrap()
        XCTAssertEqual(throwedError, error)
    }
    
    func testViewDidLoadFetchSimpleListUpdatesUserInterface() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(projectDecoders))
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, "asdsa")
    }
    
    func testViewDidLoadFetchSimpleListWithLastTaskUpdatesUserInterface() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: 2)
        self.calendarMock.isDateInTodayReturnValue = true
        self.viewModel = self.createViewModel(flowType: .newEntry(lastTask: lastTask))
        //Act
        try self.fetchProjects()
        //Assert
        XCTAssertEqual(self.userInterface.setUpParams.count, 2)
        XCTAssertEqual(self.userInterface.updateProjectParams.count, 2)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, lastTask.project?.name)
    }
    
    func testViewRequestedForNumberOfTags() {
        //Arrange
        self.viewModel.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
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
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
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
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        self.viewModel.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterface.reloadTagsViewParams.count, 2)
        XCTAssertTrue(self.viewModel.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_secondTime() {
        //Arrange
        self.viewModel.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        self.viewModel.viewSelectedTag(at: indexPath)
        self.viewModel.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterface.reloadTagsViewParams.count, 3)
        XCTAssertFalse(self.viewModel.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_outOfBounds() {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        self.viewModel.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterface.reloadTagsViewParams.count, 0)
        XCTAssertFalse(self.viewModel.isTagSelected(at: indexPath))
    }
    
    func testSetDefaultTaskWhileProjectListIsEmpty() {
        //Act
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(self.userInterface.setUpParams.isEmpty)
        XCTAssertTrue(self.userInterface.updateProjectParams.isEmpty)
    }
    
    func testSetDefaultTaskWhileProjectAfterFetchingProjectsListAndProjectNotSelected() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try (self.userInterface.setUpParams.last?.allowsTask).unwrap())
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskWasSetPreviously() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Act
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try (self.userInterface.setUpParams.last?.allowsTask).unwrap())
        XCTAssertNotEqual(self.userInterface.updateProjectParams.last?.name, "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskIsFullDayOption() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[3])
        //Act
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.count, 6)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 6)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.count, 6)
    }
    
    func testProjectButtonTappedBeforeFetch() {
        //Act
        self.viewModel.projectButtonTapped()
        //Assert
        XCTAssertTrue(try (self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty).unwrap())
    }
    
    func testProjectButtonTappedAfterFetch() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.projectButtonTapped()
        //Assert
        XCTAssertFalse(try (self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty).unwrap())
    }
    
    func testProjectButtonTappedFinishHandlerDoesNotUpdateIfProjectIsNil() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(nil)
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectParams.count, 2)
    }
    
    func testProjectButtonTappedFinishHandlerUpdatesIfProjectIsNotNil() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectParams.count, 3)
    }
    
    func testViewRequestedToFinish() {
        //Act
        self.viewModel.viewRequestedToFinish()
        //Assert
        XCTAssertEqual(self.userInterface.dismissViewParams.count, 1)
    }
    
    func testViewRequestedToSaveWhileProjectIsNil() {
        //Arrange
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        switch self.errorHandlerMock.throwingParams.last?.error as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.projectTextField)
        default: XCTFail()
        }
    }

    func testViewRequestedToSaveWhileTaskBodySetAsNilValue() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[0])
        //Act
        self.viewModel.taskNameDidChange(value: nil)
        self.viewModel.viewRequestedToSave()
        //Assert
        switch self.errorHandlerMock.throwingParams.last?.error as? UIError {
        case .cannotBeEmptyOr(let element1, let element2)?:
            XCTAssertEqual(element1, UIElement.taskNameTextField)
            XCTAssertEqual(element2, UIElement.taskUrlTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskBodyIsNil() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[0])
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        switch self.errorHandlerMock.throwingParams.last?.error as? UIError {
        case .cannotBeEmptyOr(let element1, let element2)?:
            XCTAssertEqual(element1, UIElement.taskNameTextField)
            XCTAssertEqual(element2, UIElement.taskUrlTextField)
        default: XCTFail()
        }
    }
    
    func testViewRequestedToSaveWhileTaskBodyIsNilAndURLIsNot() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        self.viewModel.taskNameDidChange(value: nil)
        //Act
        self.viewModel.taskURLDidChange(value: "www.example.com")
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsNil() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        self.viewModel.taskNameDidChange(value: "body")
        //Act
        self.viewModel.taskURLDidChange(value: nil)
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsInvalidURL() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        self.viewModel.taskNameDidChange(value: "body")
        //Act
        self.viewModel.taskURLDidChange(value: "\\INVALID//")
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLIsNil() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        self.viewModel.taskNameDidChange(value: "body")
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileProjectIsLunch() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskFromDateIsGreaterThanToDate() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[0])
        self.viewModel.taskNameDidChange(value: "body")
        self.viewModel.taskURLDidChange(value: "www.example.com")
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? UIError, .timeGreaterThan)
    }
    
    func testSetDefaultDayIfDayWasNotSet() {
        //Act
        self.viewModel.setDefaultDay()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.count, 1)
    }
    
    func testSetDefaultDayNotSetCurrentDayIfWasSetBefore() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17)
        let day = try Calendar.current.date(from: components).unwrap()
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        self.viewModel.viewChanged(day: day)
        //Act
        self.viewModel.setDefaultDay()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterface.updateDayParams.last?.dateString, dayString)
    }
    
    func testViewChangedDay() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17)
        let day = try Calendar.current.date(from: components).unwrap()
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        //Act
        self.viewModel.viewChanged(day: day)
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterface.updateDayParams.last?.dateString, dayString)
    }
    
    func testViewChangedFromDateUpdatesUpdateFromDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedFromDateUpdatesSetsMinimumDateForTypeToDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewChangedFromDateWhileToDateWasSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        //Act
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testSetDefaultFromDateWhileFromDateWasNotSet() {
        //Act
        self.viewModel.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.count, 1)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 1)
    }
    
    func testSetDefaultFromDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Act
        self.viewModel.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 2)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewChangedToDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        //Act
        self.viewModel.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedToDateWhileFromDateSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 13
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        //Act
        self.viewModel.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "1:02 PM")
    }
    
    func testSetDefaultToDate() {
        //Act
        self.viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.count, 1)
    }
    
    func testSetDefaultToDateWhileToDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        //Act
        self.viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testSetDefaultToDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Act
        self.viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewRequestedToSaveApiClientThrowsError() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        try self.fetchProjects()
        let task = try self.createTask(workTimeIdentifier: nil)
        try self.fillAllDataInViewModel(task: task)
        //Act
        self.viewModel.viewRequestedToSave()
        self.apiClient.addWorkTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual((self.errorHandlerMock.throwingParams.last?.error as? ApiClientError)?.type, error.type)
    }
    
    func testViewRequestedToSaveApiClientSucceed() throws {
        //Arrange
        try self.fetchProjects()
        let task = try self.createTask(workTimeIdentifier: nil)
        try self.fillAllDataInViewModel(task: task)
        //Act
        self.viewModel.viewRequestedToSave()
        self.apiClient.addWorkTimeParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterface.dismissViewParams.count, 1)
    }
    
    func testViewRequestedToSaveApiClient_updatesExistingWorkItem() throws {
        //Arrange
        try self.fetchProjects()
        let task = try self.createTask(workTimeIdentifier: 1)
        self.viewModel = self.createViewModel(flowType: .editEntry(editedTask: task))
        try self.fillAllDataInViewModel(task: task)
        //Act
        self.viewModel.viewRequestedToSave()
        self.apiClient.updateWorkTimeParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterface.dismissViewParams.count, 1)
    }
    
    func testViewHasBeenTappedCallsDismissKeyboardOnTheUserInterface() {
        //Act
        self.viewModel.viewHasBeenTapped()
        //Assert
        XCTAssertEqual(self.userInterface.dismissKeyboardParams.count, 1)
    }
}

// MARK: - Private
extension WorkTimeViewModelTests {
    private func fetchProjects() throws {
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        self.viewModel.viewDidLoad()
        try self.apiClient.fetchSimpleListOfProjectsParams.last.unwrap().completion(.success(projectDecoders))
    }
    
    private func createViewModel(flowType: WorkTimeViewModel.FlowType) -> WorkTimeViewModel {
        return WorkTimeViewModel(userInterface: self.userInterface,
                                 coordinator: self.coordinatorMock,
                                 apiClient: self.apiClient,
                                 errorHandler: self.errorHandlerMock,
                                 calendar: self.calendarMock,
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
                    startAt: try self.createTime(hours: 8, minutes: 0),
                    endAt: try self.createTime(hours: 9, minutes: 30),
                    tag: .default)
    }
    
    private func createTime(hours: Int, minutes: Int) throws -> Date {
        return try Calendar(identifier: .gregorian).date(bySettingHour: hours, minute: minutes, second: 0, of: Date()).unwrap()
    }
    
    private func fillAllDataInViewModel(task: Task) throws {
        let fromDate = try task.startAt.unwrap()
        let toDate = try task.endAt.unwrap()
        self.viewModel.viewChanged(day: try task.day.unwrap())
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects.first)
        self.viewModel.taskNameDidChange(value: "body")
        self.viewModel.taskURLDidChange(value: "www.example.com")
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
