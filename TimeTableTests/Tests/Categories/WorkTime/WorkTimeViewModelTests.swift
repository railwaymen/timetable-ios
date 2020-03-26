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
    private var notificationCenterMock: NotificationCenterMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = WorkTimeViewControllerMock()
        self.coordinatorMock = WorkTimeCoordinatorMock()
        self.contentProviderMock = WorkTimeContentProviderMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.calendarMock = CalendarMock()
        self.notificationCenterMock = NotificationCenterMock()
    }
}

// MARK: - keyboardFrameWillChange(_:)
extension WorkTimeViewModelTests {
    func testKeyboardFrameWillChange_withNonZeroHeight_setsProperContentInset() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let rect = CGRect(x: 0, y: 0, width: 0, height: 100)
        let notification = NSNotification(
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            userInfo: [UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: rect)])
        //Act
        sut.keyboardFrameWillChange(notification)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setBottomContentInsetParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setBottomContentInsetParams.last?.height, 100)
    }
    
    func testKeyboardFrameWillChange_withoutKeyboardHeight_doesNotSetContentInset() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let notification = NSNotification(name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //Act
        sut.keyboardFrameWillChange(notification)
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setBottomContentInsetParams.isEmpty)
    }
}

// MARK: - keyboardWillHide()
extension WorkTimeViewModelTests {
    func testKeyboardWillHide_setsContentInsetToZero() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.keyboardWillHide()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setBottomContentInsetParams.last?.height, 0)
    }
}
 
// MARK: - viewDidLoad()
extension WorkTimeViewModelTests {
    
    // MARK: New entry & without last task
    func testViewDidLoad_newEntry_withoutLastTask_setsDefaultDay() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.count, 1)
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsSaveWithFillingButtonVisible() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setSaveWithFillingButtonParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setSaveWithFillingButtonParams.last?.isHidden))
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsBodyViewVisible() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setBodyViewParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setBodyViewParams.last?.isHidden))
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsTaskURLViewVisible() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setTaskURLViewParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setTaskURLViewParams.last?.isHidden))
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsBodyTextToEmptyString() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setBodyParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setBodyParams.last?.text, "")
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsTaskURLToEmptyString() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setTaskParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setTaskParams.last?.urlString, "")
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsTagsCollectionViewHidden() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setTagsCollectionViewParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setTagsCollectionViewParams.last?.isHidden))
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsStartDate() throws {
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
    
    func testViewDidLoad_newEntry_withoutLastTask_setsMinimumEndAtDate() throws {
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
    
    func testViewDidLoad_newEntry_withoutLastTask_startDateLessThanEndDate_setsProperEndDate() throws {
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
    
    func testViewDidLoad_newEntry_withoutLastTask_startDateGreaterThanEndDate_setsProperEndDate() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startTime = try self.buildTime(hours: 10, minutes: 11)
        let endTime = try self.buildTime(hours: 9, minutes: 11)
        let formattedTime = DateFormatter.shortTime.string(from: startTime)
        self.contentProviderMock.getPredefinedTimeBoundsReturnValue = (startTime, endTime)
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, startTime)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, formattedTime)
    }
    
    func testViewDidLoad_newEntry_withoutLastTask_setsProjectName() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, "work_time.text_field.select_project".localized)
    }
    
    // MARK: Edit task
    func testViewDidLoad_withEditedTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123)
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
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setSaveWithFillingButtonParams.last?.isHidden))
    }
    
    // MARK: Duplicate task
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
        XCTAssertEqual(self.userInterfaceMock.setBodyParams.last?.text, task.body)
        XCTAssertEqual(try XCTUnwrap(self.userInterfaceMock.setTaskParams.last?.urlString), task.url?.absoluteString)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setSaveWithFillingButtonParams.last?.isHidden))
    }
    
    func testViewDidLoad_withDuplicatedTaskWithLastTask() throws {
        //Arrange
        let task = try self.createTask(workTimeIdentifier: 123, index: 3)
        let lastTask = try self.createTask(workTimeIdentifier: 12, index: 2)
        let sut = self.buildSUT(flowType: .duplicateEntry(duplicatedTask: task, lastTask: lastTask))
        let time = try XCTUnwrap(lastTask.endsAt)
        self.contentProviderMock.getPredefinedTimeBoundsReturnValue = (time, time)
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertTrue(Calendar.current.isDateInToday(try XCTUnwrap(self.userInterfaceMock.updateDayParams.last?.date)))
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, lastTask.endsAt)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, lastTask.endsAt)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, task.project?.name)
        XCTAssertEqual(self.userInterfaceMock.setBodyParams.last?.text, task.body)
        XCTAssertEqual(try XCTUnwrap(self.userInterfaceMock.setTaskParams.last?.urlString), task.url?.absoluteString)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setSaveWithFillingButtonParams.last?.isHidden))
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
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let tags: [ProjectTag] = [.default, .internalMeeting]
        sut.containerDidUpdate(projects: [], tags: tags)
        let indexPath = IndexPath(row: 1, section: 0)
        //Act
        sut.viewSelectedTag(at: indexPath)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 2)
        XCTAssertTrue(sut.isTagSelected(at: indexPath))
    }
    
    func testViewSelectedTag_secondTime() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let tags: [ProjectTag] = [.default, .internalMeeting]
        sut.containerDidUpdate(projects: [], tags: tags)
        let indexPath = IndexPath(row: 1, section: 0)
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
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
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
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
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
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
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

// MARK: - viewRequestedToSaveWithFilling()
extension WorkTimeViewModelTests {
    func testViewRequestedToSaveWithFilling_beforeRequest_showsActivityIndicator() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSaveWithFilling()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewRequestedToSaveWithFilling_beforeRequest_callsContentProvider() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSaveWithFilling()
        //Assert
        XCTAssertEqual(self.contentProviderMock.saveTaskWithFillingParams.count, 1)
    }
    
    func testViewRequestedToSaveWithFilling_resultSuccess_hidesActivityIndicator() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSaveWithFilling()
        try XCTUnwrap(self.contentProviderMock.saveTaskWithFillingParams.last).completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewRequestedToSaveWithFilling_resultSuccess_dismissesView() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSaveWithFilling()
        try XCTUnwrap(self.contentProviderMock.saveTaskWithFillingParams.last).completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.coordinatorMock.dismissViewParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.coordinatorMock.dismissViewParams.last?.isTaskChanged))
    }
    
    func testViewRequestedToSaveWithFilling_resultFailure_hidesActivityIndicator() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = TestError(message: "error")
        //Act
        sut.viewRequestedToSaveWithFilling()
        try XCTUnwrap(self.contentProviderMock.saveTaskWithFillingParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewRequestedToSaveWithFilling_resultFailure_doesNotDismissView() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = TestError(message: "error")
        //Act
        sut.viewRequestedToSaveWithFilling()
        try XCTUnwrap(self.contentProviderMock.saveTaskWithFillingParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.coordinatorMock.dismissViewParams.count, 0)
    }
    
    func testViewRequestedToSaveWithFilling_resultFailure_passesErrorToErrorHandler() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = TestError(message: "error")
        //Act
        sut.viewRequestedToSaveWithFilling()
        try XCTUnwrap(self.contentProviderMock.saveTaskWithFillingParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? TestError, error)
    }
}
    
// MARK: - viewChanged(day:)
extension WorkTimeViewModelTests {
    func testViewChangedDay_updatesDayOnUI() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let day = try self.buildDate(year: 2018, month: 1, day: 17)
        let dayString = DateFormatter.shortDate.string(from: day)
        //Act
        sut.viewChanged(day: day)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.date, day)
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.last?.dateString, dayString)
    }
}

// MARK: - viewChanged(startAtDate:)
extension WorkTimeViewModelTests {
    func testViewChangedStartAtDate_updatesStartAtDateOnTheUserInterface() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(startAtDate: startAtDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, startAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedStartAtDate_updatesEndAtDateOnTheUserInterface() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        //Act
        sut.viewChanged(startAtDate: startAtDate)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, startAtDate)
    }
    
    func testViewChangedStartAtDate_whileEndAtDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let endAtDate = try self.buildDate(year: 2018, month: 1, day: 16, hour: 12, minute: 2, second: 1)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = endAtDate
        sut.viewChanged(endAtDate: endAtDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = startAtDate
        //Act
        sut.viewChanged(startAtDate: startAtDate)
        //Assert
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
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, endAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testViewChangedEndAtDate_whileStartAtDateIsSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let endAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 13, minute: 2, second: 1)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = startAtDate
        sut.viewChanged(startAtDate: startAtDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = endAtDate
        //Act
        sut.viewChanged(endAtDate: endAtDate)
        //Assert
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
            notificationCenter: self.notificationCenterMock,
            flowType: flowType)
    }
    
    private func fetchProjects(sut: WorkTimeViewModel) throws {
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let projectDecoders = try self.decoder.decode([SimpleProjectRecordDecoder].self, from: data)
        let tagsData = try self.json(from: ProjectTagJSONResource.projectTagsResponse)
        let tagsDecoder: ProjectTagsDecoder = try self.decoder.decode(ProjectTagsDecoder.self, from: tagsData)
        sut.containerDidUpdate(projects: projectDecoders, tags: tagsDecoder.tags)
    }
    
    private func createTask(workTimeIdentifier: Int64?, index: Int = 3) throws -> TaskForm {
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let simpleProjectDecoder = try self.decoder.decode([SimpleProjectRecordDecoder].self, from: data)
        let project = try XCTUnwrap(simpleProjectDecoder[safeIndex: index])
        return TaskForm(
            workTimeIdentifier: workTimeIdentifier,
            project: project,
            body: "Blah blah blah",
            url: try XCTUnwrap(URL(string: "http://example.com")),
            day: Date(),
            startsAt: try self.buildTime(hours: 8, minutes: 0),
            endsAt: try self.buildTime(hours: 9, minutes: 30),
            tag: .default)
    }
    
    private func buildTime(hours: Int, minutes: Int) throws -> Date {
        return try XCTUnwrap(Calendar(identifier: .gregorian).date(bySettingHour: hours, minute: minutes, second: 0, of: Date()))
    }
}
// swiftlint:disable:this file_length
