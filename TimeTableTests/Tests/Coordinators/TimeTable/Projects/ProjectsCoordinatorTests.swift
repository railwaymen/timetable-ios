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
}

// MARK: - start(finishHandler: (() -> Void)?)
extension ProjectsCoordinatorTests {
    func testStart_viewControllerBuilderThrow_doesNotRunMainFlow() {
        //Arrange
        let sut = self.buildSUT()
        let error = "Error message"
        self.dependencyContainer.viewControllerBuilderMock.projectsThrownError = error
        //Act
        sut.start()
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.count, 1)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.last?.message, error)
    }
    
    func testStart_runsMainFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.dependencyContainer.viewControllerBuilderMock.projectsReturnValue = ProjectsViewController()
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
