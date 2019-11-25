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
        
    override func setUp() {
        super.setUp()
        self.userInterface = WorkTimeViewControllerMock()
        self.apiClient = ApiClientMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.calendarMock = CalendarMock()
        self.coordinatorMock = WorkTimeCoordinatorMock()
    }
    
    func testViewDidLoadSetUpUserInterfaceWithCurrentSelectedProject() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.count, 1)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, "Select project")
        XCTAssertTrue(try (self.userInterface.setUpParams.last?.allowsTask).unwrap())
    }
    
    func testViewDidLoadWithLastTaskSetsDateAndTime() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: nil)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: lastTask))
        //Act
        sut.viewDidLoad()
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
        let sut = self.buildSUT(flowType: .editEntry(editedTask: task))
        //Act
        sut.viewDidLoad()
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
        let sut = self.buildSUT(flowType: .duplicateEntry(duplicatedTask: task, lastTask: nil))
        //Act
        sut.viewDidLoad()
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
        let sut = self.buildSUT(flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask))
        //Act
        sut.viewDidLoad()
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
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertFalse(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(projectDecoders))
        //Assert
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterFailedFetch() {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.failure(error))
        //Assert
        XCTAssertTrue(try (self.userInterface.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewDidLoadFetchSimpleListCallsErrorHandlerOnFetchFailure() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.failure(error))
        //Assert
        let throwedError = try (self.errorHandlerMock.throwingParams.last?.error as? ApiClientError).unwrap()
        XCTAssertEqual(throwedError, error)
    }
    
    func testViewDidLoadFetchSimpleListUpdatesUserInterface() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(projectDecoders))
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, "asdsa")
    }
    
    func testViewDidLoadFetchSimpleListWithLastTaskUpdatesUserInterface() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: 2)
        self.calendarMock.isDateInTodayReturnValue = true
        let sut = self.buildSUT(flowType: .newEntry(lastTask: lastTask))
        //Act
        try self.fetchProjects(sut: sut)
        //Assert
        XCTAssertEqual(self.userInterface.setUpParams.count, 2)
        XCTAssertEqual(self.userInterface.updateProjectParams.count, 2)
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, lastTask.project?.name)
    }
    
    func testViewRequestedForNumberOfTags() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        //Act
        let numberOfTags = sut.viewRequestedForNumberOfTags()
        //Assert
        XCTAssertEqual(numberOfTags, 1)
    }
    
    func testViewRequestedForTag() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        //Act
        let tag = sut.viewRequestedForTag(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(tag, .internalMeeting)
    }
    
    func testViewRequestedForTag_outOfBounds() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        let tag = sut.viewRequestedForTag(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertNil(tag)
    }
    
    func testViewSelectedTag() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterface.reloadTagsViewParams.count, 2)
        XCTAssertTrue(sut.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_secondTime() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClient.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterface.reloadTagsViewParams.count, 3)
        XCTAssertFalse(sut.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_outOfBounds() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterface.reloadTagsViewParams.count, 0)
        XCTAssertFalse(sut.isTagSelected(at: indexPath))
    }
    
    func testSetDefaultTaskWhileProjectListIsEmpty() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertTrue(self.userInterface.setUpParams.isEmpty)
        XCTAssertTrue(self.userInterface.updateProjectParams.isEmpty)
    }
    
    func testSetDefaultTaskWhileProjectAfterFetchingProjectsListAndProjectNotSelected() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertTrue(try (self.userInterface.setUpParams.last?.allowsTask).unwrap())
        XCTAssertEqual(self.userInterface.updateProjectParams.last?.name, "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskWasSetPreviously() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertTrue(try (self.userInterface.setUpParams.last?.allowsTask).unwrap())
        XCTAssertNotEqual(self.userInterface.updateProjectParams.last?.name, "asdsa")
    }
    
    func testSetDefaultTaskWhileTaskIsFullDayOption() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[3])
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.count, 6)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 6)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.count, 6)
    }
    
    func testProjectButtonTappedBeforeFetch() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.projectButtonTapped()
        //Assert
        XCTAssertTrue(try (self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty).unwrap())
    }
    
    func testProjectButtonTappedAfterFetch() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        //Assert
        XCTAssertFalse(try (self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty).unwrap())
    }
    
    func testProjectButtonTappedFinishHandlerDoesNotUpdateIfProjectIsNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(nil)
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectParams.count, 2)
    }
    
    func testProjectButtonTappedFinishHandlerUpdatesIfProjectIsNotNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Assert
        XCTAssertEqual(self.userInterface.updateProjectParams.count, 3)
    }
    
    func testViewRequestedToFinish() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToFinish()
        //Assert
        XCTAssertEqual(self.userInterface.dismissViewParams.count, 1)
    }
    
    func testViewRequestedToSaveWhileProjectIsNil() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSave()
        //Assert
        switch self.errorHandlerMock.throwingParams.last?.error as? UIError {
        case .cannotBeEmpty(let element)?:
            XCTAssertEqual(element, UIElement.projectTextField)
        default: XCTFail()
        }
    }

    func testViewRequestedToSaveWhileTaskBodySetAsNilValue() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[0])
        //Act
        sut.taskNameDidChange(value: nil)
        sut.viewRequestedToSave()
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
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[0])
        //Act
        sut.viewRequestedToSave()
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
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        sut.taskNameDidChange(value: nil)
        //Act
        sut.taskURLDidChange(value: "www.example.com")
        sut.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        sut.taskNameDidChange(value: "body")
        //Act
        sut.taskURLDidChange(value: nil)
        sut.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLWasSetAsInvalidURL() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        sut.taskNameDidChange(value: "body")
        //Act
        sut.taskURLDidChange(value: "\\INVALID//")
        sut.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskURLIsNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        sut.taskNameDidChange(value: "body")
        //Act
        sut.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileProjectIsLunch() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Act
        sut.viewRequestedToSave()
        //Assert
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error as? UIError)
    }
    
    func testViewRequestedToSaveWhileTaskFromDateIsGreaterThanToDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[0])
        sut.taskNameDidChange(value: "body")
        sut.taskURLDidChange(value: "www.example.com")
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        sut.viewChanged(endAtDate: toDate)
        //Act
        sut.viewRequestedToSave()
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? UIError, .timeGreaterThan)
    }
    
    func testSetDefaultDayIfDayWasNotSet() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultDay()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.count, 1)
    }
    
    func testSetDefaultDayNotSetCurrentDayIfWasSetBefore() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 17)
        let day = try Calendar.current.date(from: components).unwrap()
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        sut.viewChanged(day: day)
        //Act
        sut.setDefaultDay()
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterface.updateDayParams.last?.dateString, dayString)
    }
    
    func testViewChangedDay() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 17)
        let day = try Calendar.current.date(from: components).unwrap()
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        //Act
        sut.viewChanged(day: day)
        //Assert
        XCTAssertEqual(self.userInterface.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterface.updateDayParams.last?.dateString, dayString)
    }
    
    func testViewChangedFromDateUpdatesUpdateFromDateOnTheUserInterface() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        sut.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedFromDateUpdatesSetsMinimumDateForTypeToDateOnTheUserInterface() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        //Act
        sut.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewChangedFromDateWhileToDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.day = 16
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        sut.viewChanged(endAtDate: toDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        //Act
        sut.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testSetDefaultFromDateWhileFromDateWasNotSet() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.count, 1)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 1)
    }
    
    func testSetDefaultFromDateWhileFromDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        //Act
        sut.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 2)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewChangedToDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        //Act
        sut.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedToDateWhileFromDateSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        var components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        components.hour = 13
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        //Act
        sut.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "1:02 PM")
    }
    
    func testSetDefaultToDate() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.count, 1)
    }
    
    func testSetDefaultToDateWhileToDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        sut.viewChanged(endAtDate: toDate)
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterface.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testSetDefaultToDateWhileFromDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let fromDate = try Calendar.current.date(from: components).unwrap()
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterface.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterface.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewRequestedToSaveApiClientThrowsError() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = ApiClientError(type: .invalidParameters)
        try self.fetchProjects(sut: sut)
        let task = try self.createTask(workTimeIdentifier: nil)
        try self.fillAllDataInViewModel(sut: sut, task: task)
        //Act
        sut.viewRequestedToSave()
        self.apiClient.addWorkTimeParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual((self.errorHandlerMock.throwingParams.last?.error as? ApiClientError)?.type, error.type)
    }
    
    func testViewRequestedToSaveApiClientSucceed() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        let task = try self.createTask(workTimeIdentifier: nil)
        try self.fillAllDataInViewModel(sut: sut, task: task)
        //Act
        sut.viewRequestedToSave()
        self.apiClient.addWorkTimeParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterface.dismissViewParams.count, 1)
    }
    
    func testViewRequestedToSaveApiClient_updatesExistingWorkItem() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 1)
        let sut = self.buildSUT(flowType: .editEntry(editedTask: task))
        try self.fetchProjects(sut: sut)
        try self.fillAllDataInViewModel(sut: sut, task: task)
        //Act
        sut.viewRequestedToSave()
        self.apiClient.updateWorkTimeParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterface.dismissViewParams.count, 1)
    }
    
    func testViewHasBeenTappedCallsDismissKeyboardOnTheUserInterface() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewHasBeenTapped()
        //Assert
        XCTAssertEqual(self.userInterface.dismissKeyboardParams.count, 1)
    }
}

// MARK: - Private
extension WorkTimeViewModelTests {
    private func buildSUT(flowType: WorkTimeViewModel.FlowType) -> WorkTimeViewModel {
        return WorkTimeViewModel(
            userInterface: self.userInterface,
            coordinator: self.coordinatorMock,
            apiClient: self.apiClient,
            errorHandler: self.errorHandlerMock,
            calendar: self.calendarMock,
            flowType: flowType)
    }
    
    private func fetchProjects(sut: WorkTimeViewModel) throws {
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        sut.viewDidLoad()
        try self.apiClient.fetchSimpleListOfProjectsParams.last.unwrap().completion(.success(projectDecoders))
    }
    
    private func createTask(workTimeIdentifier: Int64?, index: Int = 3) throws -> Task {
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let simpleProjectDecoder = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        let project = simpleProjectDecoder.projects[index]
        return Task(
            workTimeIdentifier: workTimeIdentifier,
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
    
    private func fillAllDataInViewModel(sut: WorkTimeViewModel, task: Task) throws {
        let fromDate = try task.startAt.unwrap()
        let toDate = try task.endAt.unwrap()
        sut.viewChanged(day: try task.day.unwrap())
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        sut.viewChanged(endAtDate: toDate)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects.first)
        sut.taskNameDidChange(value: "body")
        sut.taskURLDidChange(value: "www.example.com")
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
