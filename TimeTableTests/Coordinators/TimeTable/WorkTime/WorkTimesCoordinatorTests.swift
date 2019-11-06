//
//  WorkTimesCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesListCoordinatorTests: XCTestCase {
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
