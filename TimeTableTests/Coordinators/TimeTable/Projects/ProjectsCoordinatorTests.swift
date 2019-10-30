//
//  ProjectsCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectsCoordinatorTests: XCTestCase {
    private var dependencyContainer: DependencyContainerMock!
    private var projectsCoordinator: ProjectsCoordinator!
    
    override func setUp() {
        dependencyContainer = DependencyContainerMock()
        projectsCoordinator = ProjectsCoordinator(dependencyContainer: dependencyContainer)
        super.setUp() 
    }
    
    func testRunMainFlowDoesNotRunMainFlowWhileProjectsControllerIsNil() {
        //Arrange
        //Act
        projectsCoordinator.start()
        //Assert
        XCTAssertTrue(projectsCoordinator.navigationController.children.isEmpty)
    }
    
    func testRunMainFlowRunsMainFlow() {
        //Arrange
        dependencyContainer.storyboardsManagerMock.projectsController = ProjectsViewController()
        //Act
        projectsCoordinator.start()
        //Assert
        XCTAssertFalse(projectsCoordinator.navigationController.children.isEmpty)
        XCTAssertNotNil(projectsCoordinator.navigationController.children.first as? ProjectsViewControllerable)
    }
}
