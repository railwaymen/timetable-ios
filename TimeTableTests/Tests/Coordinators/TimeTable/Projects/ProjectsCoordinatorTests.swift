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
        self.dependencyContainer = DependencyContainerMock()
        self.projectsCoordinator = ProjectsCoordinator(dependencyContainer: self.dependencyContainer)
        super.setUp() 
    }
    
    func testRunMainFlowDoesNotRunMainFlowWhileProjectsControllerIsNil() {
        //Arrange
        //Act
        self.projectsCoordinator.start()
        //Assert
        XCTAssertTrue(self.projectsCoordinator.navigationController.children.isEmpty)
    }
    
    func testRunMainFlowRunsMainFlow() {
        //Arrange
        self.dependencyContainer.storyboardsManagerMock.projectsController = ProjectsViewController()
        //Act
        self.projectsCoordinator.start()
        //Assert
        XCTAssertFalse(self.projectsCoordinator.navigationController.children.isEmpty)
        XCTAssertNotNil(self.projectsCoordinator.navigationController.children.first as? ProjectsViewControllerable)
    }
}
