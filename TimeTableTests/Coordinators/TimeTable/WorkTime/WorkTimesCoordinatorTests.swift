//
//  WorkTimesCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesCoordinatorTests: XCTestCase {
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var apiClientMock: ApiClientMock!
    private var accessService: AccessServiceMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var workTimeCoordinator: WorkTimesCoordinator!
    private var messagePresenterMock: MessagePresenterMock!
    
    override func setUp() {
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.apiClientMock = ApiClientMock()
        self.accessService = AccessServiceMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.messagePresenterMock = MessagePresenterMock()
        self.workTimeCoordinator = WorkTimesCoordinator(window: nil,
                                                        messagePresenter: self.messagePresenterMock,
                                                        storyboardsManager: self.storyboardsManagerMock,
                                                        apiClient: self.apiClientMock,
                                                        accessService: self.accessService,
                                                        errorHandler: self.errorHandlerMock)
        super.setUp()
    }
    
    func testRunMainFlowDoesNotRunMainFlowWhileWorkTimesControllerIsNil() {
        //Arrange
        //Act
        workTimeCoordinator.start()
        //Assert
        XCTAssertTrue(workTimeCoordinator.navigationController.children.isEmpty)
    }
    
    func testRunMainFlowRunsMainFlow() {
        //Arrange
        storyboardsManagerMock.workTimesController = WorkTimesViewControllerMock()
        //Act
        workTimeCoordinator.start()
        //Assert
        XCTAssertFalse(workTimeCoordinator.navigationController.children.isEmpty)
        XCTAssertNotNil(workTimeCoordinator.navigationController.children.first as? WorkTimesViewControlleralbe)
    }
    
    // MARK: - WorkTimesCoordinatorDelegate
    func testWorkTimesRequestedForNewWorkTimeViewWhileStoryboardsManagerReturnedNil() {
        //Arrange
        let button = UIButton()
        //Act
        workTimeCoordinator.workTimesRequestedForNewWorkTimeView(sourceView: button, lastTask: nil)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }
    
    func testWorkTimesRequestedForNewWorkTimeViewWhileStoryboardsManagerReturnedInvalidController() {
        //Arrange
        let button = UIButton()
        storyboardsManagerMock.workTimeController = UIViewController()
        //Act
        workTimeCoordinator.workTimesRequestedForNewWorkTimeView(sourceView: button, lastTask: nil)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }

    func testWorkTimesRequestedForNewWorkTimeViewSucceed() {
        //Arrange
        let button = UIButton()
        storyboardsManagerMock.workTimeController = WorkTimeViewControllerMock()
        //Act
        workTimeCoordinator.workTimesRequestedForNewWorkTimeView(sourceView: button, lastTask: nil)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }
    
    func testWorkTimesRequestedForEditWorkTimeView_whileStoryboardsManagerReturnedNil() {
        //Arrange
        let view = UIView()
        //Act
        workTimeCoordinator.workTimesRequestedForEditWorkTimeView(sourceView: view, editedTask: createTask())
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }
    
    func testWorkTimesRequestedForEditWorkTimeView_whileStoryboardsManagerReturnedInvalidController() {
        //Arrange
        let view = UIView()
        storyboardsManagerMock.workTimeController = UIViewController()
        //Act
        workTimeCoordinator.workTimesRequestedForEditWorkTimeView(sourceView: view, editedTask: createTask())
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }
    
    func testWorkTimesRequestedForEditWorkTimeView_succeed() {
        //Arrange
        let view = UIView()
        let controllerMock = WorkTimeViewControllerMock()
        storyboardsManagerMock.workTimeController = controllerMock
        //Act
        workTimeCoordinator.workTimesRequestedForEditWorkTimeView(sourceView: view, editedTask: createTask())
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
        XCTAssertTrue(controllerMock.configureViewModelData.called)
        XCTAssertEqual(controllerMock.modalPresentationStyle, .popover)
    }
    
    func testWorkTimesRequestedForDuplicateWorkTimeView_succeed() {
        //Arrange
        let task = createTask()
        let view = UIView()
        let controllerMock = WorkTimeViewControllerMock()
        storyboardsManagerMock.workTimeController = controllerMock
        //Act
        workTimeCoordinator.workTimesRequestedForDuplicateWorkTimeView(sourceView: view, duplicatedTask: task, lastTask: task)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
        XCTAssertTrue(controllerMock.configureViewModelData.called)
        XCTAssertEqual(controllerMock.modalPresentationStyle, .popover)
    }
    
    // MAKR: - Private
    private func createTask() -> Task {
        return Task(workTimeIdentifier: 1,
                    project: nil,
                    body: "body",
                    url: nil,
                    day: Date(),
                    startAt: Date(),
                    endAt: Date().addingTimeInterval(3600),
                    tag: .default)
    }
}
