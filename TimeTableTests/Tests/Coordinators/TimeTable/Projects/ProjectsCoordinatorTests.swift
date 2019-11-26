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
    
    override func setUp() {
        super.setUp()
        self.dependencyContainer = DependencyContainerMock()
    }
    
    func testRunMainFlowDoesNotRunMainFlowWhileProjectsControllerIsNil() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.start()
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
    }
    
    func testRunMainFlowRunsMainFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.projects] = [.initial: ProjectsViewController()]
        //Act
        sut.start()
        //Assert
        XCTAssertFalse(sut.navigationController.children.isEmpty)
        XCTAssertNotNil(sut.navigationController.children.first as? ProjectsViewControllerable)
    }
}

// MARK: - Private
extension ProjectsCoordinatorTests {
    private func buildSUT() -> ProjectsCoordinator {
        return ProjectsCoordinator(dependencyContainer: self.dependencyContainer)
    }
}
