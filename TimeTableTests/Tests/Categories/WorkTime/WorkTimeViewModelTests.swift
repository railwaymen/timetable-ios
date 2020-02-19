//
//  WorkTimeViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 16/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable file_length
class WorkTimeViewModelTests: XCTestCase {
    private let projectDecoderFactory = ProjectDecoderFactory()
    private let simpleProjectDecoderFactory = SimpleProjectDecoderFactory()
    
    private var userInterfaceMock: WorkTimeViewControllerMock!
    private var coordinatorMock: WorkTimeCoordinatorMock!
    private var contentProviderMock: WorkTimeContentProviderMock!
    private var apiClientMock: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var calendarMock: CalendarMock!
    private var notificationCenterMock: NotificationCenterMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = WorkTimeViewControllerMock()
        self.coordinatorMock = WorkTimeCoordinatorMock()
        self.contentProviderMock = WorkTimeContentProviderMock()
        self.apiClientMock = ApiClientMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.calendarMock = CalendarMock()
        self.notificationCenterMock = NotificationCenterMock()
    }
}

// MARK: - keyboardFrameWillChange(_:)
extension WorkTimeViewModelTests {
    func testKeyboardFrameWillChange() {
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
    
    func testKeyboardFrameWillChange_withoutKeyboardHeight() {
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
    func testKeyboardWillHide() {
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
    
    // MARK: Fetch
    func testViewDidLoad_fetchProjectsList_makesRequest() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.contentProviderMock.fetchSimpleProjectsListParams.count, 1)
    }
    
    func testViewDidLoad_fetchProjectsList_resultSuccess() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let project = try self.projectDecoderFactory.build()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        //Act
        sut.viewDidLoad()
        try XCTUnwrap(self.contentProviderMock.fetchSimpleProjectsListParams.last).completion(.success(([project], tags)))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, project.name)
    }
    
    func testViewDidLoad_fetchProjectsList_resultFailure_apiClientError() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = ApiClientError(type: .noConnection)
        //Act
        sut.viewDidLoad()
        try XCTUnwrap(self.contentProviderMock.fetchSimpleProjectsListParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.reloadTagsViewParams.count, 0)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? ApiClientError, error)
    }
}

// MARK: - viewRequestedForNumberOfTags()
extension WorkTimeViewModelTests {
    func testViewRequestedForNumberOfTags() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        try XCTUnwrap(self.contentProviderMock.fetchSimpleProjectsListParams.last).completion(.success(([], tags)))
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
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        try XCTUnwrap(self.contentProviderMock.fetchSimpleProjectsListParams.last).completion(.success(([], tags)))
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
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        try XCTUnwrap(self.contentProviderMock.fetchSimpleProjectsListParams.last).completion(.success(([], tags)))
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
        sut.viewDidLoad()
        let tags: [ProjectTag] = [.default, .internalMeeting]
        try XCTUnwrap(self.contentProviderMock.fetchSimpleProjectsListParams.last).completion(.success(([], tags)))
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

// MARK: - setDefaultTask()
extension WorkTimeViewModelTests {
    func testSetDefaultTask_whileProjectListIsEmpty() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertTrue(self.userInterfaceMock.setUpParams.isEmpty)
        XCTAssertTrue(self.userInterfaceMock.updateProjectParams.isEmpty)
    }
    
    func testSetDefaultTask_afterFetchingProjectsListAndProjectIsNotSelected() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.allowsTask))
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.last?.name, "asdsa")
    }
    
    func testSetDefaultTask_whileTaskWasSetPreviously() throws {
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
    
    func testSetDefaultTask_whileTaskIsFullDayOption() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects[3])
        //Act
        sut.setDefaultTask()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.count, 8)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 8)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.count, 8)
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
    
    func testProjectButtonTapped_finishHandlerDoesNotUpdateIfProjectIsNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(nil)
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.count, 2)
    }
    
    func testProjectButtonTapped_finishHandlerUpdatesIfProjectIsNotNil() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        try self.fetchProjects(sut: sut)
        //Act
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(coordinatorMock.showProjectPickerParams.last?.projects[1])
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateProjectParams.count, 3)
    }
}

// MARK: - viewRequestedToFinish()
extension WorkTimeViewModelTests {
    func testViewRequestedToFinish() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToFinish()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.dismissViewParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.viewDidFinishParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.coordinatorMock.viewDidFinishParams.last?.isTaskChanged))
    }
}

// MARK: - viewRequestedToSave()
extension WorkTimeViewModelTests {
    func testViewRequestedToSave_callsContentProvider() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSave()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.contentProviderMock.saveTaskParams.count, 1)
    }
    
    func testViewRequestedToSave_resultSuccess() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.dismissViewParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.viewDidFinishParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.coordinatorMock.viewDidFinishParams.last?.isTaskChanged))
    }
    
    func testViewRequestedToSave_resultFailure_apiClientError() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = ApiClientError(type: .noConnection)
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.dismissViewParams.count, 0)
        XCTAssertEqual(self.coordinatorMock.viewDidFinishParams.count, 0)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? ApiClientError, error)
    }
    
    func testViewRequestedToSave_resultFailure_uiError() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let error = UIError.genericError
        //Act
        sut.viewRequestedToSave()
        try XCTUnwrap(self.contentProviderMock.saveTaskParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.dismissViewParams.count, 0)
        XCTAssertEqual(self.coordinatorMock.viewDidFinishParams.count, 0)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.last?.error as? UIError, error)
    }
}

// MARK: - setDefaultDay()
extension WorkTimeViewModelTests {
    func testSetDefaultDay_ifDayWasNotSet() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultDay()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateDayParams.count, 1)
    }

    func testSetDefaultDay_notSetCurrentDayIfWasSetBefore() throws {
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
}
    
// MARK: - viewChanged(day:)
extension WorkTimeViewModelTests {
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

// MARK: - setDefaultStartAtDate()
extension WorkTimeViewModelTests {
    func testSetDefaultStartAtDate_whileStartAtDateWasNotSet() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
    }
    
    func testSetDefaultStartAtDate_whileStartAtDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = startAtDate
        sut.viewChanged(startAtDate: startAtDate)
        //Act
        sut.setDefaultStartAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, startAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 2)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, startAtDate)
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

// MARK: - setDefaultEndAtDate()
extension WorkTimeViewModelTests {
    func testSetDefaultEndAtDate() {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.count, 1)
    }
    
    func testSetDefaultEndAtDate_whileEndAtDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let endAtDate = try XCTUnwrap(self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1))
        self.calendarMock.dateBySettingCalendarComponentReturnValue = endAtDate
        sut.viewChanged(endAtDate: endAtDate)
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.date, endAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateEndAtDateParams.last?.dateString, "12:02 PM")
    }
    
    func testSetDefaultEndAtDate_whileStartAtDateWasSet() throws {
        //Arrange
        let sut = self.buildSUT(flowType: .newEntry(lastTask: nil))
        let startAtDate = try XCTUnwrap(self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1))
        self.calendarMock.dateBySettingCalendarComponentReturnValue = startAtDate
        sut.viewChanged(startAtDate: startAtDate)
        //Act
        sut.setDefaultEndAtDate()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.date, startAtDate)
        XCTAssertEqual(self.userInterfaceMock.updateStartAtDateParams.last?.dateString, "12:02 PM")
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setMinimumDateForTypeEndAtDateParams.last?.minDate, startAtDate)
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
        try XCTUnwrap(self.contentProviderMock.fetchSimpleProjectsListParams.last).completion(.success((projectDecoders.projects, projectDecoders.tags)))
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
        let startAtDate = try XCTUnwrap(task.startsAt)
        let endAtDate = try XCTUnwrap(task.endsAt)
        sut.viewChanged(day: try XCTUnwrap(task.day))
        self.calendarMock.dateBySettingCalendarComponentReturnValue = startAtDate
        sut.viewChanged(startAtDate: startAtDate)
        self.calendarMock.dateBySettingCalendarComponentReturnValue = endAtDate
        sut.viewChanged(endAtDate: endAtDate)
        sut.projectButtonTapped()
        self.coordinatorMock.showProjectPickerParams.last?.finishHandler(self.coordinatorMock.showProjectPickerParams.last?.projects.first)
        sut.taskNameDidChange(value: "body")
        sut.taskURLDidChange(value: "www.example.com")
    }
}

private extension Task {
    func isTaskValidationError(equalTo: TaskValidationError?) -> Bool {
        do {
            try self.validate()
            return equalTo == nil
        } catch {
            guard let error = error as? TaskValidationError else { return false }
            return error == equalTo
        }
    }
}
// swiftlint:enable file_length
