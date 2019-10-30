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
    private var dependencyContainer: DependencyContainerMock!
    private var workTimeCoordinator: WorkTimesListCoordinator!
    
    override func setUp() {
        dependencyContainer = DependencyContainerMock()
        workTimeCoordinator = WorkTimesListCoordinator(dependencyContainer: dependencyContainer)
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
        dependencyContainer.storyboardsManagerMock.workTimesListController = WorkTimesListViewControllerMock()
        //Act
        workTimeCoordinator.start()
        //Assert
        XCTAssertFalse(workTimeCoordinator.navigationController.children.isEmpty)
        XCTAssertNotNil(workTimeCoordinator.navigationController.children.first as? WorkTimesListViewControllerable)
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
        dependencyContainer.storyboardsManagerMock.workTimeController = UIViewController()
        //Act
        workTimeCoordinator.workTimesRequestedForNewWorkTimeView(sourceView: button, lastTask: nil)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }

    func testWorkTimesRequestedForNewWorkTimeViewSucceed() {
        //Arrange
        let button = UIButton()
        dependencyContainer.storyboardsManagerMock.workTimeController = WorkTimeViewControllerMock()
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
        dependencyContainer.storyboardsManagerMock.workTimeController = UIViewController()
        //Act
        workTimeCoordinator.workTimesRequestedForEditWorkTimeView(sourceView: view, editedTask: createTask())
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }
    
    func testWorkTimesRequestedForEditWorkTimeView_succeed() {
        //Arrange
        let view = UIView()
        let controllerMock = WorkTimeViewControllerMock()
        dependencyContainer.storyboardsManagerMock.workTimeController = controllerMock
        //Act
        workTimeCoordinator.workTimesRequestedForEditWorkTimeView(sourceView: view, editedTask: createTask())
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
        XCTAssertTrue(controllerMock.configureViewModelData.called)
    }
    
    func testWorkTimesRequestedForDuplicateWorkTimeView_succeed() {
        //Arrange
        let task = createTask()
        let view = UIView()
        let controllerMock = WorkTimeViewControllerMock()
        dependencyContainer.storyboardsManagerMock.workTimeController = controllerMock
        //Act
        workTimeCoordinator.workTimesRequestedForDuplicateWorkTimeView(sourceView: view, duplicatedTask: task, lastTask: task)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
        XCTAssertTrue(controllerMock.configureViewModelData.called)
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
