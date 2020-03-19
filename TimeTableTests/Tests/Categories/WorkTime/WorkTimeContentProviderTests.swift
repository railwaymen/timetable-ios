//
//  WorkTimeContentProviderTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable file_length
class WorkTimeContentProviderTests: XCTestCase {
    private let projectFactory = SimpleProjectRecordDecoderFactory()
    private let simpleProjectDecoderFactory = SimpleProjectDecoderFactory()
    private let taskFactory = TaskFactory()
    
    private var apiClient: ApiClientMock!
    private var calendar: CalendarMock!
    private var dateFactory: DateFactoryMock!
    private var taskForm: TaskFormMock!
    
    override func setUp() {
        super.setUp()
        self.apiClient = ApiClientMock()
        self.calendar = CalendarMock()
        self.dateFactory = DateFactoryMock()
        self.taskForm = TaskFormMock()
    }
}

// MARK: - fetchSimpleProjectsList(completion:)
extension WorkTimeContentProviderTests {
    func testFetchSimpleProjectsList_resultSuccess() throws {
        //Arrange
        let sut = self.buildSUT()
        let projectWithoutIsActive = try self.projectFactory.build(wrapper: .init(isActive: nil))
        let activeProject = try self.projectFactory.build(wrapper: .init(isActive: true))
        let inactiveProject = try self.projectFactory.build(wrapper: .init(isActive: false))
        let projects = [activeProject, inactiveProject, projectWithoutIsActive]
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProject = try self.simpleProjectDecoderFactory.build(wrapper: .init(projects: projects, tags: tags))
        var completionResult: FetchSimpleProjectsListResult?
        //Act
        sut.fetchSimpleProjectsList { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.fetchSimpleListOfProjectsParams.last).completion(.success(simpleProject))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get().projects, [activeProject])
        XCTAssertEqual(try XCTUnwrap(completionResult).get().tags, [.internalMeeting])
    }
    
    func testFetchSimpleProjectsList_resultFailure() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = ApiClientError(type: .invalidResponse)
        var completionResult: FetchSimpleProjectsListResult?
        //Act
        sut.fetchSimpleProjectsList { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.fetchSimpleListOfProjectsParams.last).completion(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: error)
    }
}

// MARK: - save(taskForm:completion:)
extension WorkTimeContentProviderTests {
    func testSaveTask_formValidationError_projectIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.projectIsNil
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.cannotBeEmpty(.projectTextField))
    }
    
    func testSaveTask_formValidationError_urlIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.urlIsNil
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.cannotBeEmpty(.taskUrlTextField))
    }
    
    func testSaveTask_formValidationError_bodyIsEmpty() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.bodyIsEmpty
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.cannotBeEmpty(.taskNameTextField))
    }
    
    func testSaveTask_formValidationError_dayIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.dayIsNil
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.cannotBeEmpty(.dayTextField))
    }
    
    func testSaveTask_formValidationError_startsAtIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.startsAtIsNil
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.cannotBeEmpty(.startsAtTextField))
    }
    
    func testSaveTask_formValidationError_endsAtIsNil() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.endsAtIsNil
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.cannotBeEmpty(.endsAtTextField))
    }
    
    func testSaveTask_formValidationError_timeRangeIsIncorrect() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.timeRangeIsIncorrect
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.timeGreaterThan)
    }
    
    func testSaveTask_formValidationError_internalError() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationThrownError = TaskForm.ValidationError.internalError
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: UIError.genericError)
    }
    
    func testSaveTask_updatesEditedTask() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.workTimeIdentifier = 133
        self.taskForm.generateEncodableRepresentationReturnValue = try self.buildTask()
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.apiClient.updateWorkTimeParams.count, 1)
        XCTAssertEqual(self.apiClient.updateWorkTimeParams.last?.identifier, 133)
    }
    
    func testSaveTask_updateTaskRequestSuccess() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.workTimeIdentifier = 133
        self.taskForm.generateEncodableRepresentationReturnValue = try self.buildTask()
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.updateWorkTimeParams.last).completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.apiClient.updateWorkTimeParams.count, 1)
        XCTAssertNoThrow(try XCTUnwrap(completionResult).get())
    }
    
    func testSaveTask_updateTaskRequestFailure() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "error")
        self.taskForm.workTimeIdentifier = 133
        self.taskForm.generateEncodableRepresentationReturnValue = try self.buildTask()
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.updateWorkTimeParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.apiClient.updateWorkTimeParams.count, 1)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testSaveTask_addsNewTask() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationReturnValue = try self.buildTask()
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.apiClient.addWorkTimeParams.count, 1)
    }
    
    func testSaveTask_addTaskRequestSuccess() throws {
        //Arrange
        let sut = self.buildSUT()
        self.taskForm.generateEncodableRepresentationReturnValue = try self.buildTask()
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.addWorkTimeParams.last).completion(.success(Void()))
        //Assert
        XCTAssertEqual(self.apiClient.addWorkTimeParams.count, 1)
        XCTAssertNoThrow(try XCTUnwrap(completionResult).get())
    }
    
    func testSaveTask_addTaskRequestFailure() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "error")
        self.taskForm.generateEncodableRepresentationReturnValue = try self.buildTask()
        var completionResult: SaveTaskResult?
        //Act
        sut.save(taskForm: self.taskForm) { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.addWorkTimeParams.last).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.apiClient.addWorkTimeParams.count, 1)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - getPredefinedTimeBounds(forTaskForm:lastTask:)
extension WorkTimeContentProviderTests {
    
    // MARK: projectType == .fullDay
    
    func testGetPredefinedTimeBounds_fullDayProject() throws {
        //Arrange
        let sut = self.buildSUT()
        self.dateFactory.currentDateReturnValue = try self.buildDate(year: 2011, month: 2, day: 23)
        let expectedStartDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 9, minute: 0, second: 0)
        self.calendar.dateBySettingHourReturnValue = expectedStartDate
        self.taskForm.projectTypeReturnValue = .fullDay(100)
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(self.calendar.dateBySettingHourParams.count, 1)
        XCTAssertEqual(startDate, expectedStartDate)
        XCTAssertEqual(endDate, try self.buildDate(year: 2011, month: 2, day: 23, hour: 9, minute: 1, second: 40))
    }
    
    func testGetPredefinedTimeBounds_fullDayProject_withoutCalendarDate() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.dateFactory.currentDateReturnValue = currentDate
        self.taskForm.projectTypeReturnValue = .fullDay(100)
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(self.calendar.dateBySettingHourParams.count, 1)
        XCTAssertEqual(startDate, currentDate)
        XCTAssertEqual(endDate, try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 33, second: 42))
    }
    
    // MARK: projectType == .lunch
    
    func testGetPredefinedTimeBounds_lunchProject() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.taskForm.projectTypeReturnValue = .lunch(100)
        self.taskForm.startsAt = currentDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(startDate, currentDate)
        XCTAssertEqual(endDate, currentDate.addingTimeInterval(100))
    }
    
    func testGetPredefinedTimeBounds_lunchProject_withoutTaskStartTime() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.dateFactory.currentDateReturnValue = currentDate
        self.taskForm.projectTypeReturnValue = .lunch(100)
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(startDate, currentDate.roundedToFiveMinutes())
        XCTAssertEqual(endDate, currentDate.roundedToFiveMinutes().addingTimeInterval(100))
    }
    
    // MARK: projectType == .standard

    func testGetPredefinedTimeBounds_standardProject_lastTaskEndTimeAndTaskEndTimeExist() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedStartDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        let expectedEndDate = try self.buildDate(year: 2019, month: 6, day: 16, hour: 2, minute: 5, second: 1)
        self.taskForm.projectTypeReturnValue = .standard
        self.taskForm.endsAt = expectedEndDate
        self.calendar.isDateInTodayReturnValue = true
        let lastTaskForm = TaskFormMock()
        lastTaskForm.endsAt = expectedStartDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: lastTaskForm)
        //Assert
        XCTAssertEqual(startDate, expectedStartDate)
        XCTAssertEqual(endDate, expectedEndDate)
    }
    
    func testGetPredefinedTimeBounds_standardProject_lastTaskEndTimeExists() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.taskForm.projectTypeReturnValue = .standard
        self.calendar.isDateInTodayReturnValue = true
        let lastTaskForm = TaskFormMock()
        lastTaskForm.endsAt = currentDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: lastTaskForm)
        //Assert
        XCTAssertEqual(startDate, currentDate)
        XCTAssertEqual(endDate, currentDate)
    }
    
    func testGetPredefinedTimeBounds_standardProject_taskStartTimeExists() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.taskForm.projectTypeReturnValue = .standard
        self.taskForm.startsAt = currentDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(startDate, currentDate)
        XCTAssertEqual(endDate, currentDate)
    }
    
    func testGetPredefinedTimeBounds_standardProject_getsCurrentDate() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.taskForm.projectTypeReturnValue = .standard
        self.dateFactory.currentDateReturnValue = currentDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(startDate, currentDate.roundedToFiveMinutes())
        XCTAssertEqual(endDate, currentDate.roundedToFiveMinutes())
    }
    
    // MARK: projectType == .none
    
    func testGetPredefinedTimeBounds_nilProject_lastTaskEndTimeAndTaskEndTimeExist() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedStartDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        let expectedEndDate = try self.buildDate(year: 2019, month: 6, day: 16, hour: 2, minute: 5, second: 1)
        self.taskForm.projectTypeReturnValue = nil
        self.taskForm.endsAt = expectedEndDate
        self.calendar.isDateInTodayReturnValue = true
        let lastTaskForm = TaskFormMock()
        lastTaskForm.endsAt = expectedStartDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: lastTaskForm)
        //Assert
        XCTAssertEqual(startDate, expectedStartDate)
        XCTAssertEqual(endDate, expectedEndDate)
    }
    
    func testGetPredefinedTimeBounds_nilProject_lastTaskEndTimeExists() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.taskForm.projectTypeReturnValue = nil
        self.calendar.isDateInTodayReturnValue = true
        let lastTaskForm = TaskFormMock()
        lastTaskForm.endsAt = currentDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: lastTaskForm)
        //Assert
        XCTAssertEqual(startDate, currentDate)
        XCTAssertEqual(endDate, currentDate)
    }
    
    func testGetPredefinedTimeBounds_nilProject_taskStartTimeExists() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.taskForm.projectTypeReturnValue = nil
        self.taskForm.startsAt = currentDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(startDate, currentDate)
        XCTAssertEqual(endDate, currentDate)
    }
    
    func testGetPredefinedTimeBounds_nilProject_getsCurrentDate() throws {
        //Arrange
        let sut = self.buildSUT()
        let currentDate = try self.buildDate(year: 2011, month: 2, day: 23, hour: 6, minute: 32, second: 2)
        self.taskForm.projectTypeReturnValue = nil
        self.dateFactory.currentDateReturnValue = currentDate
        //Act
        let (startDate, endDate) = sut.getPredefinedTimeBounds(forTaskForm: self.taskForm, lastTask: nil)
        //Assert
        XCTAssertEqual(startDate, currentDate.roundedToFiveMinutes())
        XCTAssertEqual(endDate, currentDate.roundedToFiveMinutes())
    }
}

// MARK: - getPredefinedDay(forTaskForm:)
extension WorkTimeContentProviderTests {
    func testGetPredefinedDay_taskHasDay() throws {
        //Arrange
        let sut = self.buildSUT()
        let date = try self.buildDate(year: 2018, month: 12, day: 11)
        let taskForm = TaskForm(body: "", day: date)
        //Act
        let returnedDate = sut.getPredefinedDay(forTaskForm: taskForm)
        //Assert
        XCTAssertEqual(returnedDate, date)
    }
    
    func testGetPredefinedDay_nilDay() throws {
        //Arrange
        let sut = self.buildSUT()
        let date = try self.buildDate(year: 2018, month: 12, day: 11)
        self.dateFactory.currentDateReturnValue = date
        let taskForm = TaskForm(body: "", day: nil)
        //Act
        let returnedDate = sut.getPredefinedDay(forTaskForm: taskForm)
        //Assert
        XCTAssertEqual(returnedDate, date)
    }
}

// MARK: - pickEndTime(ofLastTask:)
extension WorkTimeContentProviderTests {
    func testPickEndTimeOfLastTask_nilTask() throws {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let date = sut.pickEndTime(ofLastTask: nil)
        //Assert
        XCTAssertNil(date)
    }
    
    func testPickEndTimeOfLastTask_nilEndsAt() throws {
        //Arrange
        let sut = self.buildSUT()
        let lastTask = TaskForm(body: "")
        //Act
        let date = sut.pickEndTime(ofLastTask: lastTask)
        //Assert
        XCTAssertNil(date)
    }
    
    func testPickEndTimeOfLastTask_endsAtNotToday() throws {
        //Arrange
        let sut = self.buildSUT()
        let endsAt = try self.buildDate(year: 2019, month: 5, day: 1)
        let lastTask = TaskForm(body: "", endsAt: endsAt)
        self.calendar.isDateInTodayReturnValue = false
        //Act
        let date = sut.pickEndTime(ofLastTask: lastTask)
        //Assert
        XCTAssertNil(date)
    }
    
    func testPickEndTimeOfLastTask_endsAtToday() throws {
        //Arrange
        let sut = self.buildSUT()
        let endsAt = try self.buildDate(year: 2019, month: 5, day: 1)
        let lastTask = TaskForm(body: "", endsAt: endsAt)
        self.calendar.isDateInTodayReturnValue = true
        //Act
        let date = sut.pickEndTime(ofLastTask: lastTask)
        //Assert
        XCTAssertEqual(date, endsAt)
    }
}

// MARK: - Private
extension WorkTimeContentProviderTests {
    private func buildSUT() -> WorkTimeContentProvider {
        return WorkTimeContentProvider(
            apiClient: self.apiClient,
            calendar: self.calendar,
            dateFactory: self.dateFactory)
    }
    
    private func buildTask() throws -> Task {
        return Task(
            project: try self.projectFactory.build(),
            body: "",
            startsAt: Date(),
            endsAt: Date())
    }
}
// swiftlint:enable file_length
