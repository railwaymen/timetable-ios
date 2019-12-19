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
    private var userInterfaceMock: WorkTimeViewControllerMock!
    private var coordinatorMock: WorkTimeCoordinatorMock!
    private var apiClientMock: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var notificationCenterMock: NotificationCenterMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = WorkTimeViewControllerMock()
        self.apiClientMock = ApiClientMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.calendarMock = CalendarMock()
        self.coordinatorMock = WorkTimeCoordinatorMock()
        self.notificationCenterMock = NotificationCenterMock()
    }
    
    func testViewDidLoadSetUpUserInterfaceWithCurrentSelectedProject() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, "Select project")
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask))
    }
    
    func testViewDidLoadWithLastTaskSetsDateAndTime() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: nil)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: lastTask))
        let creationDate = Date()
        let timestampRoundingFactor = 5 * TimeInterval.minute
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try XCTUnwrap(self.userInterfaceMock.updateDayParams.last?.date)))
        let startsAtDate = try XCTUnwrap(self.userInterfaceMock.updateStartAtDateParams.last?.date)
        let endsAtDate = try XCTUnwrap(self.userInterfaceMock.updateEndAtDateParams.last?.date)
        XCTAssertEqual(startsAtDate.timeIntervalSince1970.remainder(dividingBy: timestampRoundingFactor), 0)
        XCTAssertEqual(startsAtDate.timeIntervalSince1970, creationDate.timeIntervalSince1970, accuracy: timestampRoundingFactor / 2 + 0.01)
        XCTAssertEqual(endsAtDate.timeIntervalSince1970.remainder(dividingBy: timestampRoundingFactor), 0)
        XCTAssertEqual(endsAtDate.timeIntervalSince1970, creationDate.timeIntervalSince1970, accuracy: timestampRoundingFactor / 2 + 0.01)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, "Select project")
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask))
    }
    
    func testViewDidLoad_withEditedTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123)
        let sut = self.buildSUT(flowType: .editEntry(editedTask: task))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.date, task.day)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, task.startsAt)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, task.endsAt)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.body, task.body)
        XCTAssertNotNil(self.userInterfaceMock.setUpParams.last?.urlString)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithoutLastTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123)
        let sut = self.buildSUT(flowType: .duplicateEntry(duplicatedTask: task, lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertNotEqual(self.userInterfaceMock.updateDayParams.last?.date, task.day)
        XCTAssertNotEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, task.startsAt)
        XCTAssertNotEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, task.endsAt)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.body, task.body)
        XCTAssertNotNil(self.userInterfaceMock.setUpParams.last?.urlString)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask), task.allowsTask)
    }
    
    func testViewDidLoad_withDuplicatedTaskWithLastTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123, index: 3)
        let lastTask = try self.createTask(workTimeIdentifier: 12, index: 2)
        let sut = self.buildSUT(flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try XCTUnwrap(self.userInterfaceMock.updateDayParams.last?.date)))
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, lastTask.endsAt)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, lastTask.endsAt)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.body, task.body)
        XCTAssertNotNil(self.userInterfaceMock.setUpParams.last?.urlString)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.urlString, task.url?.absoluteString)
        XCTAssertEqual(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask), task.allowsTask)
    }
    
    func testViewDidLoadFetchSimpleListShowsActivityIndicatorBeforeFetch() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterSuccessfulFetch() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(projectDecoders))
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewDidLoadFetchSimpleListHidesActivityIndicatorAfterFailedFetch() {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.failure(error))
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewDidLoadFetchSimpleListCallsErrorHandlerOnFetchFailure() throws {
        //Arrange
        let error = ApiClientError(type: .invalidParameters)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.failure(error))
        //Assert
        let throwedError = try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? ApiClientError)
        XCTAssertEqual(throwedError, error)
    }
    
    func testViewDidLoadFetchSimpleListUpdatesUserInterface() throws {
        //Arrange
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(projectDecoders))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, "asdsa")
    }
    
    func testViewDidLoadFetchSimpleListWithLastTaskUpdatesUserInterface() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeIdentifier: 2)
        self.calendarMock.isDateInTodayReturnValue = true
        let sut = self.buildSUT(flowType: .newEntry(lastTask: lastTask))
        //Act
        try self.fetchProjects(sut: sut)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, lastTask.project?.name)
    }
    
    func testViewRequestedForNumberOfTags() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
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
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
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
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 2)
        XCTAssertTrue(sut.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_secondTime() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProjectDecoder = SimpleProjectDecoder(projects: [], tags: tags)
        self.apiClientMock.fetchSimpleListOfProjectsParams.last?.completion(.success(simpleProjectDecoder))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 3)
        XCTAssertFalse(sut.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_outOfBounds() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 0)
        XCTAssertFalse(sut.isTagSelected(at: indexPath))
    }
    
    func testSetDefaultTaskWhileProjectListIsEmpty() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setUpParams.isEmpty)
        XCTAssertTrue(self.userInterfaceMock.updateProjectParams.isEmpty)
    }
    
    func testSetDefaultTaskWhileProjectAfterFetchingProjectsListAndProjectNotSelected() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask))
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, "asdsa")
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
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask))
        XCTAssertNotEqual(self.userInterfaceMock.updateProjectParams.last?.name, "asdsa")
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
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.count, 6)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 6)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.count, 6)
    }
    
    func testProjectButtonTappedBeforeFetch() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.projectButtonTapped()
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty))
    }
    
    func testProjectButtonTappedAfterFetch() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty))
    }
    
    func testProjectButtonTappedFinishHandlerDoesNotUpdateIfProjectIsNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(nil)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.count, 2)
    }
    
    func testProjectButtonTappedFinishHandlerUpdatesIfProjectIsNotNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.count, 3)
    }
    
    func testViewRequestedToFinish() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToFinish()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.dismissViewParams.count, 1)
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
        case let .cannotBeEmpty(element):
            XCTAssertEqual(element, UIElement.taskNameTextField)
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
        case let .cannotBeEmpty(element):
            XCTAssertEqual(element, UIElement.taskNameTextField)
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
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error)
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
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error)
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
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error)
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
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error)
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
        XCTAssertNil(self.errorHandlerMock.throwingParams.last?.error)
    }
    
    func testViewRequestedToSaveWhileTaskFromDateIsGreaterThanToDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let fromDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try self.buildDate(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
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
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.count, 1)
    }
    
    func testSetDefaultDayNotSetCurrentDayIfWasSetBefore() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let day = try self.buildDate(year: 2018, month: 1, day: 17)
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        sut.viewChanged(day: day)
        //Act
        sut.setDefaultDay()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.dateString, dayString)
    }
    
    func testViewChangedDay() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let day = try self.buildDate(year: 2018, month: 1, day: 17)
        let dayString = DateFormatter.localizedString(from: day, dateStyle: .short, timeStyle: .none)
        //Act
        sut.viewChanged(day: day)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.dateString, dayString)
    }
    
    func testViewChangedFromDateUpdatesUpdateFromDateOnTheUserInterface() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let fromDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedFromDateUpdatesSetsMinimumDateForTypeToDateOnTheUserInterface() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let fromDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewChangedFromDateWhileToDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let fromDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try self.buildDate(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        sut.viewChanged(endAtDate: toDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        //Act
        sut.viewChanged(startAtDate: fromDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testSetDefaultFromDateWhileFromDateWasNotSet() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
    }
    
    func testSetDefaultFromDateWhileFromDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let fromDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        //Act
        sut.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
    }
    
    func testViewChangedToDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let toDate = try self.buildDate(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedToDateWhileFromDateSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let fromDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let toDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 13, minute: 2, second: 1)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        //Act
        sut.viewChanged(endAtDate: toDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "1:02 PM")
    }
    
    func testSetDefaultToDate() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.count, 1)
    }
    
    func testSetDefaultToDateWhileToDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let toDate = try XCTUnwrap(self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1))
        self.calendarMock.dateBySettingCalendarComponentReturnValue = toDate
        sut.viewChanged(endAtDate: toDate)
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, toDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testSetDefaultToDateWhileFromDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let fromDate = try XCTUnwrap(self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1))
        self.calendarMock.dateBySettingCalendarComponentReturnValue = fromDate
        sut.viewChanged(startAtDate: fromDate)
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, fromDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, fromDate)
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
        self.apiClientMock.addWorkTimeParams.last?.completion(.failure(error))
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
        self.apiClientMock.addWorkTimeParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.dismissViewParams.count, 1)
    }
    
    func testViewRequestedToSaveApiClient_updatesExistingWorkItem() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 1)
        let sut = self.buildSUT(flowType: .editEntry(editedTask: task))
        try self.fetchProjects(sut: sut)
        try self.fillAllDataInViewModel(sut: sut, task: task)
        //Act
        sut.viewRequestedToSave()
        self.apiClientMock.updateWorkTimeParams.last?.completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.dismissViewParams.count, 1)
    }
    
    func testViewHasBeenTappedCallsDismissKeyboardOnTheUserInterface() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewHasBeenTapped()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.dismissKeyboardParams.count, 1)
    }
}

// MARK: - Private
extension WorkTimeViewModelTests {
    private func buildSUT(flowType: WorkTimeViewModel.FlowType) -> WorkTimeViewModel {
        return WorkTimeViewModel(
            userInterface: self.userInterfaceMock,
            coordinator: self.coordinatorMock,
            apiClient: self.apiClientMock,
            errorHandler: self.errorHandlerMock,
            calendar: self.calendarMock,
            notificationCenter: self.notificationCenterMock,
            flowType: flowType)
    }
    
    private func fetchProjects(sut: WorkTimeViewModel) throws {
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        sut.viewDidLoad()
        try XCTUnwrap(self.apiClientMock.fetchSimpleListOfProjectsParams.last).completion(.success(projectDecoders))
    }
    
    private func createTask(workTimeIdentifier: Int64?, index: Int = 3) throws -> Task {
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let simpleProjectDecoder = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        let project = simpleProjectDecoder.projects[index]
        return Task(
            workTimeIdentifier: workTimeIdentifier,
            project: project,
            body: "Blah blah blah",
            url: try XCTUnwrap(URL(string: "http://example.com")),
            day: Date(),
            startsAt: try self.createTime(hours: 8, minutes: 0),
            endsAt: try self.createTime(hours: 9, minutes: 30),
            tag: .default)
    }
    
    private func createTime(hours: Int, minutes: Int) throws -> Date {
        return try XCTUnwrap(Calendar(identifier: .gregorian).date(bySettingHour: hours, minute: minutes, second: 0, of: Date()))
    }
    
    private func fillAllDataInViewModel(sut: WorkTimeViewModel, task: Task) throws {
        let fromDate = try XCTUnwrap(task.startsAt)
        let toDate = try XCTUnwrap(task.endsAt)
        sut.viewChanged(day: try XCTUnwrap(task.day))
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
