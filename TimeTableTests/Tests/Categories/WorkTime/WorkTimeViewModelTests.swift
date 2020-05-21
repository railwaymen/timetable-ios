//
//  WorkTimeViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeViewModelTests: XCTestCase {
    private let projectDecoderFactory = SimpleProjectRecordDecoderFactory()
    
    private var userInterfaceMock: WorkTimeViewControllerMock!
    private var coordinatorMock: WorkTimeCoordinatorMock!
    private var contentProviderMock: WorkTimeContentProviderMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var keyboardManagerMock: KeyboardManagerMock!
    private var notificationCenterMock: NotificationCenterMock!
    private var taskForm: TaskFormMock!
    private var taskFormFactoryMock: TaskFormFactoryMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = WorkTimeViewControllerMock()
        self.coordinatorMock = WorkTimeCoordinatorMock()
        self.contentProviderMock = WorkTimeContentProviderMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.calendarMock = CalendarMock()
        self.keyboardManagerMock = KeyboardManagerMock()
        self.notificationCenterMock = NotificationCenterMock()
        self.taskForm = TaskFormMock()
        self.taskFormFactoryMock = TaskFormFactoryMock()
        self.taskFormFactoryMock.buildTaskFormReturnValue = self.taskForm
    }
}

// MARK: - Initialization
extension WorkTimeViewModelTests {
    func testInitialization_newEntry_buildsTaskForm() throws {
        //Arrange
        let lastTask = try self.createTask(workTimeID: 12)
        //Act
        _ = self.buildSUT(flowType: .newEntry(lastTask: lastTask))
        //Assert
        XCTAssertEqual(self.taskFormFactoryMock.buildTaskFormParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.taskFormFactoryMock.buildTaskFormParams.last).duplicatedTask)
        XCTAssertEqual(try XCTUnwrap(self.taskFormFactoryMock.buildTaskFormParams.last).lastTask, lastTask)
    }
    
    func testInitialization_editEntry_doesNotBuildTaskForm() throws {
        //Arrange
        let task = try self.createTask(workTimeID: 123)
        //Act
        _ = self.buildSUT(flowType: .editEntry(editedTask: task))
        //Assert
        XCTAssertEqual(self.taskFormFactoryMock.buildTaskFormParams.count, 0)
    }
    
    func testInitialization_duplicateEntry_buildsTaskForm() throws {
        //Arrange
        let task = try self.createTask(workTimeID: 123)
        let lastTask = try self.createTask(workTimeID: 12)
        //Act
        _ = self.buildSUT(flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask))
        //Assert
        XCTAssertEqual(self.taskFormFactoryMock.buildTaskFormParams.count, 1)
        XCTAssertEqual(try XCTUnwrap(self.taskFormFactoryMock.buildTaskFormParams.last).duplicatedTask, task)
        XCTAssertEqual(try XCTUnwrap(self.taskFormFactoryMock.buildTaskFormParams.last).lastTask, lastTask)
    }
}
 
// MARK: - viewDidLoad()
extension WorkTimeViewModelTests {
    
    // MARK: New entry
    func testViewDidLoad_newEntry_setsUpUI() throws {
        //Arrange
        self.taskForm.allowsTaskReturnValue = true
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setSaveWithFillingIsHiddenParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setSaveWithFillingIsHiddenParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.setBodyViewParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setBodyViewParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.setTaskURLViewParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setTaskURLViewParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.setBodyParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setBodyParams.last?.text, "")
        XCTAssertEqual(self.userInterfaceMock.setTaskParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setTaskParams.last?.urlString, "")
        XCTAssertEqual(self.userInterfaceMock.setTagsCollectionViewParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setTagsCollectionViewParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, "worktimeform_select_project".localized)
    }
    
    func testViewDidLoad_newEntry_setsStartDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startTime = try self.buildTime(hours: 9, minutes: 11)
        let formattedTime = DateFormatter.shortTime.string(from: startTime)
        self.contentProviderMock.getPredefinedTimeBoundsReturnValue = (startTime, Date())
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, startTime)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, formattedTime)
    }
    
    func testViewDidLoad_newEntry_setsMinimumEndAtDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startTime = try self.buildTime(hours: 9, minutes: 11)
        self.contentProviderMock.getPredefinedTimeBoundsReturnValue = (startTime, Date())
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, startTime)
    }
    
    func testViewDidLoad_newEntry_startDateLessThanEndDate_setsProperEndDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startTime = try self.buildTime(hours: 8, minutes: 11)
        let endTime = try self.buildTime(hours: 9, minutes: 11)
        let formattedTime = DateFormatter.shortTime.string(from: endTime)
        self.contentProviderMock.getPredefinedTimeBoundsReturnValue = (startTime, endTime)
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, endTime)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, formattedTime)
    }
    
    func testViewDidLoad_newEntry_startDateGreaterThanEndDate_setsProperEndDate() throws {
        //Arrange
        let taskForm = TaskFormMock()
        self.taskFormFactoryMock.buildTaskFormReturnValue = taskForm
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startingTime = try self.buildTime(hours: 1, minutes: 57)
        let startTime = try self.buildTime(hours: 10, minutes: 11)
        let endTime = try self.buildTime(hours: 9, minutes: 11)
        let formattedTime = DateFormatter.shortTime.string(from: startTime)
        taskForm.startsAtReturnValue = startingTime
        taskForm.endsAtReturnValue = startingTime
        self.contentProviderMock.getPredefinedTimeBoundsReturnValue = (startTime, endTime)
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, startTime)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, formattedTime)
    }
    
    // MARK: Edit entry
    func testViewDidLoad_editEntry_setsUpUI() throws {
        //Arrange
        let task = try self.createTask(workTimeID: 123)
        let sut = self.buildSUT(flowType: .editEntry(editedTask: task))
        self.contentProviderMock.getPredefinedDayReturnValue = try XCTUnwrap(task.day)
        self.contentProviderMock.getPredefinedTimeBoundsReturnValue = (try XCTUnwrap(task.startsAt), try XCTUnwrap(task.endsAt))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.date, task.day)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, task.startsAt)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, task.endsAt)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterfaceMock.setBodyParams.last?.text, task.body)
        XCTAssertEqual(try XCTUnwrap(self.userInterfaceMock.setTaskParams.last?.urlString), task.url?.absoluteString)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setSaveWithFillingIsHiddenParams.last?.isHidden))
    }
}

// MARK: - viewRequestedForNumberOfTags()
extension WorkTimeViewModelTests {
    func testViewRequestedForNumberOfTags() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let tags: [ProjectTag] = [.default, .internalMeeting]
        sut.containerDidUpdate(projects: [], tags: tags)
        //Act
        let numberOfTags = sut.viewRequestedForNumberOfTags()
        //Assert
        XCTAssertEqual(numberOfTags, 2)
    }
}

// MARK: - viewRequestedForTag(at:)
extension WorkTimeViewModelTests {
    func testViewRequestedForTag() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let tags: [ProjectTag] = [.default, .internalMeeting]
        sut.containerDidUpdate(projects: [], tags: tags)
        //Act
        let tag = sut.viewRequestedForTag(at: IndexPath(row: 1, section: 0))
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
}

// MARK: - viewSelectedTag(at:)
extension WorkTimeViewModelTests {
    func testViewSelectedTag() throws {
        //Arrange
        let taskForm = TaskFormMock()
        self.taskFormFactoryMock.buildTaskFormReturnValue = taskForm
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let tags: [ProjectTag] = [.default, .internalMeeting]
        sut.containerDidUpdate(projects: [], tags: tags)
        let indexPath = IndexPath(row: 1, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 2)
        XCTAssertEqual(taskForm.tagSetParams.count, 1)
        XCTAssertEqual(taskForm.tagSetParams.last?.newValue, tags[indexPath.row])
    }
    
    func testViewSelectedTag_alreadySelectedTag() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let tags: [ProjectTag] = [.default, .internalMeeting]
        sut.containerDidUpdate(projects: [], tags: tags)
        let indexPath = IndexPath(row: 1, section: 0)
        self.taskForm.tagReturnValue = .internalMeeting
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 2)
        XCTAssertEqual(self.taskForm.tagSetParams.count, 1)
        XCTAssertEqual(try XCTUnwrap(self.taskForm.tagSetParams.last).newValue, .default)
    }
    
    func testViewSelectedTag_outOfBounds() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 0)
        XCTAssertEqual(self.taskForm.tagSetParams.count, 0)
    }
}

// MARK: - taskURLDidChange(value:)
extension WorkTimeViewModelTests {
    func testTaskURLDidChange_properURL_setsProperURL() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let url = "example.com"
        //Act
        sut.taskURLDidChange(value: url)
        //Assert
        XCTAssertEqual(self.taskForm.urlStringSetParams.count, 1)
        XCTAssertEqual(self.taskForm.urlStringSetParams.last?.newValue, url)
    }
    
    func testTaskURLDidChange_nilValue_setsEmptyStringInTaskForm() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.taskURLDidChange(value: nil)
        //Assert
        XCTAssertEqual(self.taskForm.urlStringSetParams.count, 1)
        XCTAssertEqual(try XCTUnwrap(self.taskForm.urlStringSetParams.last).newValue, "")
    }
    
    func testTaskURLDidChange_emptyString_setsEmptyStringInTaskForm() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.taskURLDidChange(value: "")
        //Assert
        XCTAssertEqual(self.taskForm.urlStringSetParams.count, 1)
        XCTAssertEqual(try XCTUnwrap(self.taskForm.urlStringSetParams.last).newValue, "")
    }
    
    func testTaskURLDidChange_whiteSpaces_setsItInTaskForm() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let url = "   "
        //Act
        sut.taskURLDidChange(value: url)
        //Assert
        XCTAssertEqual(self.taskForm.urlStringSetParams.count, 1)
        XCTAssertEqual(try XCTUnwrap(self.taskForm.urlStringSetParams.last).newValue, url)
    }
}

// MARK: - projectButtonTapped()
extension WorkTimeViewModelTests {
    func testProjectButtonTapped_beforeFetch() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.projectButtonTapped()
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty))
    }
    
    func testProjectButtonTapped_afterFetch() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        //Assert
        XCTAssertFalse(try XCTUnwrap(self.coordinatorMock.showProjectPickerParams.last?.projects.isEmpty))
    }
}

// MARK: - viewRequestedToSave()
extension WorkTimeViewModelTests {
    func testViewRequestedToSave_beforeRequest_showsActivityIndicator() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSave()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isAnimating))
    }
    
    func testViewRequestedToSave_beforeRequest_callsContentProvider() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSave()
        //Assert
        XCTAssertEqual(self.contentProviderMock.saveTaskParams.count, 1)
    }
    
    func testViewRequestedToSave_resultSuccess_hidesActivityIndicator() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isAnimating))
    }
    
    func testViewRequestedToSave_resultSuccess_dismissesView() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.coordinatorMock.dismissViewParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.coordinatorMock.dismissViewParams.last?.isTaskChanged))
    }
    
    func testViewRequestedToSave_resultFailure_hidesActivityIndicator() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = TestError(message: "error")
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isAnimating))
    }
    
    func testViewRequestedToSave_resultFailure_doesNotDismissView() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = TestError(message: "error")
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.coordinatorMock.dismissViewParams.count, 0)
    }
    
    func testViewRequestedToSave_resultFailure_passesErrorToErrorHandler() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = TestError(message: "error")
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? TestError, error)
    }
}
    
// MARK: - viewChanged(day:)
extension WorkTimeViewModelTests {
    func testViewChangedDay_updatesDay() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let day = try self.buildDate(year: 2018, month: 1, day: 17)
        let dayString = DateFormatter.shortDate.string(from: day)
        //Act
        sut.viewChanged(day: day)
        //Assert
        XCTAssertEqual(self.taskForm.daySetParams.count, 1)
        XCTAssertEqual(self.taskForm.daySetParams.last?.newValue, day)
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.dateString, dayString)
    }
}

// MARK: - viewChanged(startAtDate:)
extension WorkTimeViewModelTests {
    func testViewChangedStartAtDate_updatesStartAtDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(startAtDate: startAtDate)
        //Assert
        XCTAssertEqual(taskForm.startsAtParams.count, 1)
        XCTAssertEqual(taskForm.startsAtParams.last?.newValue, startAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, startAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedStartAtDate_setsEndAtDateOnUI() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(startAtDate: startAtDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, startAtDate)
    }
    
    func testViewChangedStartAtDate_whileEndAtDateWasSet_updatesEndAtDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let endAtDate = try self.buildDate(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        taskForm.endsAtReturnValue = endAtDate
        //Act
        sut.viewChanged(startAtDate: startAtDate)
        //Assert
        XCTAssertEqual(taskForm.endsAtParams.count, 1)
        XCTAssertEqual(taskForm.endsAtParams.last?.newValue, startAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, startAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
}

// MARK: - viewChanged(endAtDate:)
extension WorkTimeViewModelTests {
    func testViewChangedEndAtDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let endAtDate = try self.buildDate(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(endAtDate: endAtDate)
        //Assert
        XCTAssertEqual(self.taskForm.endsAtParams.count, 1)
        XCTAssertEqual(self.taskForm.endsAtParams.last?.newValue, endAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, endAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedEndAtDate_whileStartAtDateIsSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let endAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 13, minute: 2, second: 1)
        self.taskForm.startsAtReturnValue = startAtDate
        //Act
        sut.viewChanged(endAtDate: endAtDate)
        //Assert
        XCTAssertEqual(self.taskForm.endsAtParams.count, 1)
        XCTAssertEqual(self.taskForm.endsAtParams.last?.newValue, endAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, endAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "1:02 PM")
    }
}

// MARK: - viewHasBeenTapped()
extension WorkTimeViewModelTests {
    func testViewHasBeenTapped_callsDismissKeyboardOnTheUserInterface() {
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
            contentProvider: self.contentProviderMock,
            errorHandler: self.errorHandlerMock,
            calendar: self.calendarMock,
            keyboardManager: self.keyboardManagerMock,
            flowType: flowType,
            taskFormFactory: self.taskFormFactoryMock)
    }
    
    private func fetchProjects(sut: WorkTimeViewModel) throws {
        let projectDecoders = [
            try self.projectDecoderFactory.build(wrapper: SimpleProjectRecordDecoderFactory.Wrapper(id: 1)),
            try self.projectDecoderFactory.build(wrapper: SimpleProjectRecordDecoderFactory.Wrapper(id: 2)),
            try self.projectDecoderFactory.build(wrapper: SimpleProjectRecordDecoderFactory.Wrapper(id: 4))
        ]
        let tags: [ProjectTag] = [
            .development,
            .clientCommunication,
            .internalMeeting,
            .research
        ]
        sut.containerDidUpdate(projects: projectDecoders, tags: tags)
    }
    
    private func createTask(workTimeID: Int64?) throws -> TaskForm {
        let project = try self.projectDecoderFactory.build()
        return TaskForm(
            workTimeID: workTimeID,
            project: project,
            body: "Blah blah blah",
            urlString: "http://example.com",
            day: Date(),
            startsAt: try self.buildTime(hours: 8, minutes: 0),
            endsAt: try self.buildTime(hours: 9, minutes: 30),
            tag: .default)
    }
    
    private func buildTime(hours: Int, minutes: Int) throws -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return try XCTUnwrap(calendar.date(bySettingHour: hours, minute: minutes, second: 0, of: Date()))
    }
}
// swiftlint:disable:this file_length
