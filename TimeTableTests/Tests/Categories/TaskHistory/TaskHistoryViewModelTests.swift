//
//  TaskHistoryViewModelTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskHistoryViewModelTests: XCTestCase {
    private var userInterface: TaskHistoryViewControllerMock!
    private var coordinator: TaskHistoryCoordinatorMock!
    private var apiClient: ApiClientMock!
    private var errorHandler: ErrorHandlerMock!
    private var taskForm: TaskFormMock!
    
    override func setUp() {
        super.setUp()
        self.userInterface = TaskHistoryViewControllerMock()
        self.coordinator = TaskHistoryCoordinatorMock()
        self.apiClient = ApiClientMock()
        self.errorHandler = ErrorHandlerMock()
        self.taskForm = TaskFormMock()
        self.taskForm.workTimeIDReturnValue = 1
    }
}

// MARK: - viewDidLoad()
extension TaskHistoryViewModelTests {
    func testViewDidLoad_setsUpUserInterface() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.setUpParams.count, 1)
    }
    
    func testViewDidLoad_fetchWorkTimeDetails_before_taskWithoutWorkTimeID_stopsInDebug() {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.workTimeIDReturnValue = nil
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.errorHandler.stopInDebugParams.count, 1)
    }
    
    func testViewDidLoad_fetchWorkTimeDetails_before_showsActivityIndicator() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.userInterface.setActivityIndicatorParams.last?.isAnimating))
    }
    
    func testViewDidLoad_fetchWorkTimeDetails_before_requestsAPIClientForData() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.apiClient.fetchWorkTimeDetailsParams.count, 1)
    }
    
    func testViewDidLoad_fetchWorkTimeDetails_success_hidesActivityIndicator() throws {
        //Arrange
        let sut = self.buildSUT()
        let workTime = try self.buildWorkTimeDecoder()
        //Act
        sut.viewDidLoad()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.success(workTime))
        //Assert
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterface.setActivityIndicatorParams.last?.isAnimating))
    }
    
    func testViewDidLoad_fetchWorkTimeDetails_success_reloadsData() throws {
        //Arrange
        let sut = self.buildSUT()
        let workTime = try self.buildWorkTimeDecoder()
        //Act
        sut.viewDidLoad()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.success(workTime))
        //Assert
        XCTAssertEqual(self.userInterface.reloadDataParams.count, 1)
    }
    
    func testViewDidLoad_fetchWorkTimeDetails_failure_hidesActivityIndicator() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "test error")
        //Act
        sut.viewDidLoad()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.userInterface.setActivityIndicatorParams.count, 2)
        XCTAssertFalse(try XCTUnwrap(self.userInterface.setActivityIndicatorParams.last?.isAnimating))
    }
    
    func testViewDidLoad_fetchWorkTimeDetails_failure_passesErrorToErrorHandler() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "test error")
        //Act
        sut.viewDidLoad()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.errorHandler.throwingParams.count, 1)
        XCTAssertEqual(self.errorHandler.throwingParams.last?.error as? TestError, error)
    }
}

// MARK: - numberOfSections()
extension TaskHistoryViewModelTests {
    func testNumberOfSections_returnsProperValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let numberOfSections = sut.numberOfSections()
        //Assert
        XCTAssertEqual(numberOfSections, 1)
    }
}

// MARK: - numberOfRows(in:)
extension TaskHistoryViewModelTests {
    func testNumberOfRows_withoutWorkTime_returnsProperValue() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let numberOfRows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRows_withWorkTime_forSection0_returnsProperValue() throws {
        //Arrange
        let sut = self.buildSUT()
        let workTime = try self.buildWorkTimeDecoder()
        sut.viewDidLoad()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.success(workTime))
        //Act
        let numberOfRows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testNumberOfRows_withWorkTime_forSection1_returnsProperValue() throws {
        //Arrange
        let sut = self.buildSUT()
        let workTime = try self.buildWorkTimeDecoder()
        sut.viewDidLoad()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.success(workTime))
        //Act
        let numberOfRows = sut.numberOfRows(in: 1)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
}

// MARK: - configure(_:for:)
extension TaskHistoryViewModelTests {
    func testConfigureCell_withoutWorkTime_doesNotCallConfigureOnCoordinator() {
        //Arrange
        let sut = self.buildSUT()
        let cell = WorkTimeTableViewCell()
        //Act
        sut.configure(cell, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinator.configureParams.count, 0)
    }
    
    func testConfigureCell_withWorkTime_forIndexInBounds_callsConfigureOnCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        sut.viewDidLoad()
        let workTime = try self.buildWorkTimeDecoder()
        let firstVersion = try XCTUnwrap(workTime.versions.first)
        let expectedWorkTime = WorkTimeDisplayed(workTime: workTime, version: firstVersion)
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.success(workTime))
        let cell = WorkTimeTableViewCell()
        //Act
        sut.configure(cell, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinator.configureParams.count, 1)
        XCTAssertEqual(self.coordinator.configureParams.last?.cell, cell)
        XCTAssertEqual(self.coordinator.configureParams.last?.workTime, expectedWorkTime)
    }
    
    func testConfigureCell_withWorkTime_forIndexOutOfBounds_doesNotCallConfigureOnCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        sut.viewDidLoad()
        let workTime = try self.buildWorkTimeDecoder()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.success(workTime))
        let cell = WorkTimeTableViewCell()
        //Act
        sut.configure(cell, for: IndexPath(row: 1, section: 0))
        //Assert
        XCTAssertEqual(self.coordinator.configureParams.count, 0)
    }
    
    func testConfigureCell_withWorkTime_forSection1_doesNotCallConfigureOnCoordinator() throws {
        //Arrange
        let sut = self.buildSUT()
        sut.viewDidLoad()
        let workTime = try self.buildWorkTimeDecoder()
        try XCTUnwrap(self.apiClient.fetchWorkTimeDetailsParams.last).completion(.success(workTime))
        let cell = WorkTimeTableViewCell()
        //Act
        sut.configure(cell, for: IndexPath(row: 0, section: 1))
        //Assert
        XCTAssertEqual(self.coordinator.configureParams.count, 0)
    }
}

// MARK: - closeButtonTapped()
extension TaskHistoryViewModelTests {
    func testCloseButtonTapped_callsDismissOnCoordinator() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.closeButtonTapped()
        //Assert
        XCTAssertEqual(self.coordinator.dismissParams.count, 1)
    }
}

// MARK: - Private
extension TaskHistoryViewModelTests {
    private func buildSUT() -> TaskHistoryViewModel {
        return TaskHistoryViewModel(
            userInterface: self.userInterface,
            coordinator: self.coordinator,
            apiClient: self.apiClient,
            errorHandler: self.errorHandler,
            taskForm: self.taskForm)
    }
    
    private func buildWorkTimeDecoder() throws -> WorkTimeDecoder {
        let project = try SimpleProjectRecordDecoderFactory().build()
        let version = try TaskVersionFactory().build(
            event: TaskVersion.Event.create,
            updatedBy: "user 1",
            updatedAt: Date(),
            projectName: NilableDiffElement(previous: "", current: "project Name"),
            body: NilableDiffElement(previous: "", current: "body"),
            startsAt: NilableDiffElement(previous: Date(), current: Date()),
            endsAt: NilableDiffElement(previous: Date(), current: Date()),
            tag: NilableDiffElement(previous: ProjectTag.default, current: ProjectTag.development),
            duration: NilableDiffElement(previous: 120, current: 180),
            task: NilableDiffElement(previous: "task", current: "new task"),
            taskPreview: NilableDiffElement(previous: "prev", current: "task preview"))
        let wrapper = WorkTimeDecoderFactory.Wrapper(
            id: 16239,
            projectID: 3,
            duration: 3600,
            body: "body",
            task: "task",
            taskPreview: "preview",
            userID: 2,
            project: project,
            versions: [version])
        let decoder = try WorkTimeDecoderFactory().build(wrapper: wrapper)
        return try XCTUnwrap(decoder)
    }
}
