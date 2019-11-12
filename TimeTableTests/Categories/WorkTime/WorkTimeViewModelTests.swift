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
        XCTAssertNotNil(self.userInterface.updateDayValues.date)
        XCTAssertEqual(self.userInterface.updateProjectName, "Select project")
        XCTAssertTrue(try (self.userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
    }
    
    func testViewDidLoadWithLastTaskSetsDateAndTime() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: nil)
        self.viewModel = self.createViewModel(flowType: .newEntry(lastTask: lastTask))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try self.userInterface.updateDayValues.date.unwrap()))
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateProjectName, "Select project")
        XCTAssertTrue(try (self.userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
    }
    
    func testViewDidLoad_withEditedTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123)
        self.viewModel = self.createViewModel(flowType: .editEntry(editedTask: task))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayValues.date, task.day)
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.date, task.startAt)
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.date, task.endAt)
        XCTAssertEqual(self.userInterface.updateProjectName, task.project?.name)
        XCTAssertEqual(self.userInterface.setUpCurrentProjectName?.body, task.body)
        XCTAssertNotNil(self.userInterface.setUpCurrentProjectName?.urlString)
        XCTAssertEqual(self.userInterface.setUpCurrentProjectName?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (self.userInterface.setUpCurrentProjectName?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithoutLastTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123)
        self.viewModel = self.createViewModel(flowType: .duplicateEntry(duplicatedTask: task, lastTask: nil))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertNotEqual(self.userInterface.updateDayValues.date, task.day)
        XCTAssertNotEqual(self.userInterface.updateStartAtDateValues.date, task.startAt)
        XCTAssertNotEqual(self.userInterface.updateEndAtDateValues.date, task.endAt)
        XCTAssertEqual(self.userInterface.updateProjectName, task.project?.name)
        XCTAssertEqual(self.userInterface.setUpCurrentProjectName?.body, task.body)
        XCTAssertNotNil(self.userInterface.setUpCurrentProjectName?.urlString)
        XCTAssertEqual(self.userInterface.setUpCurrentProjectName?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (self.userInterface.setUpCurrentProjectName?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithLastTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123, index: 3)
        let lastTask = try self.createTask(workTimeIdentifier: 12, index: 2)
        self.viewModel = self.createViewModel(flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask))
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try self.userInterface.updateDayValues.date.unwrap()))
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.date, lastTask.endAt)
        XCTAssertEqual(self.userInterface.updateProjectName, task.project?.name)
        XCTAssertEqual(self.userInterface.setUpCurrentProjectName?.body, task.body)
        XCTAssertNotNil(self.userInterface.setUpCurrentProjectName?.urlString)
        XCTAssertEqual(self.userInterface.setUpCurrentProjectName?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try (self.userInterface.setUpCurrentProjectName?.allowsTask).unwrap(), task.allowsTask)
    }
    
    func testViewDidLoadFetchSimpleListShowsActivityIndicatorBeforeFetch() throws {
        //Act
        self.viewModel.viewDidLoad()
        //Assert
        XCTAssertFalse(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.success(projectDecoders))
        //Assert
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterFailedFetch() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.failure(error))
        //Assert
        XCTAssertTrue(try self.userInterface.setActivityIndicatorIsHidden.unwrap())
    }
    
    func testViewDidLoadFetchSimpleListCallsErrorHandlerOnFetchFailure() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.failure(error))
        //Assert
        let throwedError = try (self.errorHandlerMock.throwedError as? ApiClientError).unwrap()
        XCTAssertEqual(throwedError, error)
    }
    
    func testViewDidLoadFetchSimpleListUpdatesUserInterface() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        //Act
        self.viewModel.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsCompletion?(.success(projectDecoders))
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectName, "asdsa")
    }
    
    func testViewDidLoadFetchSimpleListWithLastTaskUpdatesUserInterface() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: 2)
        self.calendarMock.isDateInTodayReturnValue = true
        self.viewModel = self.createViewModel(flowType: .newEntry(lastTask: lastTask))
        //Act
        try self.fetchProjects()
        //Assert
        XCTAssertNotNil(self.userInterface.setUpCurrentProjectName)
        XCTAssertEqual(self.userInterface.updateProjectName, lastTask.project?.name)
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
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertNil(self.userInterface.setUpCurrentProjectName?.allowsTask)
        XCTAssertNil(self.userInterface.updateProjectName)
    }
    
    func testSetDefaultTaskWhileProjectAfterFetchingProjectsListAndProjectNotSelected() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try (self.userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
        XCTAssertEqual(try self.userInterface.updateProjectName.unwrap(), "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskWasSetPreviously() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[1])
        //Act
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertTrue(try (self.userInterface.setUpCurrentProjectName?.allowsTask).unwrap())
        XCTAssertNotEqual(try self.userInterface.updateProjectName.unwrap(), "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskIsFullDayOption() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[3])
        //Act
        self.viewModel.setDefaultTask()
        //Assert
        XCTAssertNotNil(self.userInterface.updateStartAtDateValues.date)
        XCTAssertNotNil(self.userInterface.updateStartAtDateValues.dateString)
        XCTAssertTrue(self.userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertNotNil(self.userInterface.setMinimumDateForTypeToDateValues.minDate)
        XCTAssertNotNil(self.userInterface.updateEndAtDateValues.date)
        XCTAssertNotNil(self.userInterface.updateEndAtDateValues.dateString)
    }
    
    func testProjectButtonTappedBeforeFetch() {
        //Act
        self.viewModel.projectButtonTapped()
        //Assert
        XCTAssertTrue(try (self.coordinatorMock.showProjectPickerProjects?.isEmpty).unwrap())
    }
    
    func testProjectButtonTappedAfterFetch() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.projectButtonTapped()
        //Assert
        XCTAssertFalse(try (self.coordinatorMock.showProjectPickerProjects?.isEmpty).unwrap())
    }
    
    func testProjectButtonTappedFinishHandlerDoesNotUpdateIfProjectIsNil() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(nil)
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectCalledCount, 2)
    }
    
    func testProjectButtonTappedFinishHandlerUpdatesIfProjectIsNotNil() throws {
        //Arrange
        try self.fetchProjects()
        //Act
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(coordinatorMock.showProjectPickerProjects?[1])
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectCalledCount, 3)
    }
    
    func testViewRequestedToFinish() {
        //Act
        self.viewModel.viewRequestedToFinish()
        //Assert
        XCTAssertTrue(self.userInterface.dismissViewCalled)
    }
    
    func testViewRequestedToSaveWhileProjectIsNil() {
        //Arrange
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        switch self.errorHandlerMock.throwedError as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.projectTextField)
        default: XCTFail()
        }
    }

    func testViewRequestedToSaveWhileTaskBodySetAsNilValue() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[0])
        //Act
        self.viewModel.taskNameDidChange(value: nil)
        self.viewModel.viewRequestedToSave()
        //Assert
        switch self.errorHandlerMock.throwedError as? UIError {
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
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[0])
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        switch self.errorHandlerMock.throwedError as? UIError {
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
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[1])
        self.viewModel.taskNameDidChange(value: nil)
        //Act
        self.viewModel.taskURLDidChange(value: "www.example.com")
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwedError as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsNil() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[1])
        self.viewModel.taskNameDidChange(value: "body")
        //Act
        self.viewModel.taskURLDidChange(value: nil)
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwedError as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsInvalidURL() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[1])
        self.viewModel.taskNameDidChange(value: "body")
        //Act
        self.viewModel.taskURLDidChange(value: "\\INVALID//")
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwedError as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLIsNil() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[1])
        self.viewModel.taskNameDidChange(value: "body")
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwedError as? UIError)
    }
    
    func testViewRequestedToSaveWhileProjectIsLunch() throws {
        //Arrange
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[1])
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwedError as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskFromDateIsGreaterThanToDate() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        try self.fetchProjects()
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?[0])
        self.viewModel.taskNameDidChange(value: "body")
        self.viewModel.taskURLDidChange(value: "www.example.com")
        self.calendarMock.dateBySettingReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        //Act
        self.viewModel.viewRequestedToSave()
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwedError as? UIError, .timeGreaterThan)
    }
    
    func testSetDefaultDayIfDayWasNotSet() {
        //Act
        self.viewModel.setDefaultDay()
        //Assert
        XCTAssertNotNil(self.userInterface.updateDayValues.date)
        XCTAssertNotNil(self.userInterface.updateDayValues.dateString)
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
        XCTAssertEqual(self.userInterface.updateDayValues.date, day)
        XCTAssertEqual(self.userInterface.updateDayValues.dateString, dayString)
    }
    
    func testViewChangedDay() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17)
        let day = try Calendar.current.date(from: components).unwrap()
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        //Act
        self.viewModel.viewChanged(day: day)
        //Assert
        XCTAssertEqual(self.userInterface.updateDayValues.date, day)
        XCTAssertEqual(self.userInterface.updateDayValues.dateString, dayString)
    }
    
    func testViewChangedFromDateUpdatesUpdateFromDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.dateString, "12:02 PM")
    }
    
    func testViewChangedFromDateUpdatesSetsMinimumDateForTypeToDateOnTheUserInterface() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertTrue(self.userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
    }
    
    func testViewChangedFromDateWhileToDateWasSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        self.calendarMock.dateBySettingReturnValue = fromDate
        //Act
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.date, fromDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.dateString, "12:02 PM")
    }
    
    func testSetDefaultFromDateWhileFromDateWasNotSet() {
        //Act
        self.viewModel.setDefaultStartAtDate()
        //Assert
        XCTAssertNotNil(self.userInterface.updateStartAtDateValues.date)
        XCTAssertNotNil(self.userInterface.updateStartAtDateValues.dateString)
        XCTAssertTrue(self.userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertNotNil(self.userInterface.setMinimumDateForTypeToDateValues.minDate)
    }
    
    func testSetDefaultFromDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Act
        self.viewModel.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.dateString, "12:02 PM")
        XCTAssertTrue(self.userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
    }
    
    func testViewChangedToDate() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        //Act
        self.viewModel.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.dateString, "12:02 PM")
    }
    
    func testViewChangedToDateWhileFromDateSet() throws {
        //Arrange
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 13
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingReturnValue = toDate
        //Act
        self.viewModel.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.dateString, "1:02 PM")
    }
    
    func testSetDefaultToDate() {
        //Act
        self.viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertNotNil(self.userInterface.updateEndAtDateValues.date)
        XCTAssertNotNil(self.userInterface.updateEndAtDateValues.dateString)
    }
    
    func testSetDefaultToDateWhileToDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        //Act
        self.viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateValues.dateString, "12:02 PM")
    }
    
    func testSetDefaultToDateWhileFromDateWasSet() throws {
        //Arrange
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        //Act
        self.viewModel.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateValues.dateString, "12:02 PM")
        XCTAssertTrue(self.userInterface.setMinimumDateForTypeToDateValues.called)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeToDateValues.minDate, fromDate)
    }
    
    func testViewRequestedToSaveApiClientThrowsError() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        try self.fetchProjects()
        let task = try self.createTask(workTimeIdentifier: nil)
        try self.fillAllDataInViewModel(task: task)
        //Act
        self.viewModel.viewRequestedToSave()
        self.apiClient.addWorkTimeComletion?(.failure(error))
        //Assert
        XCTAssertEqual((self.errorHandlerMock.throwedError as? ApiClientError)?.type, error.type)
    }
    
    func testViewRequestedToSaveApiClientSucceed() throws {
        //Arrange
        try self.fetchProjects()
        let task = try self.createTask(workTimeIdentifier: nil)
        try self.fillAllDataInViewModel(task: task)
        //Act
        self.viewModel.viewRequestedToSave()
        self.apiClient.addWorkTimeComletion?(.success(Void()))
        //Assert
        XCTAssertTrue(self.userInterface.dismissViewCalled)
    }
    
    func testViewRequestedToSaveApiClient_updatesExistingWorkItem() throws {
        //Arrange
        try self.fetchProjects()
        let task = try self.createTask(workTimeIdentifier: 1)
        self.viewModel = self.createViewModel(flowType: .editEntry(editedTask: task))
        try self.fillAllDataInViewModel(task: task)
        //Act
        self.viewModel.viewRequestedToSave()
        self.apiClient.updateWorkTimeCompletion?(.success(Void()))
        //Assert
        XCTAssertTrue(self.userInterface.dismissViewCalled)
    }
    
    func testViewHasBeenTappedCallsDismissKeyboardOnTheUserInterface() {
        //Act
        self.viewModel.viewHasBeenTapped()
        //Assert
        XCTAssertTrue(self.userInterface.dismissKeyboardCalled)
    }
    
    // MARK: - Private
    private func fetchProjects() throws {
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        self.viewModel.viewDidLoad()
        try self.apiClient.fetchSimpleListOfProjectsCompletion.unwrap()(.success(projectDecoders))
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
        self.calendarMock.dateBySettingReturnValue = fromDate
        self.viewModel.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingReturnValue = toDate
        self.viewModel.viewChanged(endAtDate: toDate)
        self.viewModel.projectButtonTapped()
        self.coordinatorMock.showProjectPickerFinishHandler?(self.coordinatorMock.showProjectPickerProjects?.first)
        self.viewModel.taskNameDidChange(value: "body")
        self.viewModel.taskURLDidChange(value: "www.example.com")
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
