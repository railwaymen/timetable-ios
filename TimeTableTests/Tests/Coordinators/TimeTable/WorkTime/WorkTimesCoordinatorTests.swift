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
    
    override func setUp() {
        self.dependencyContainer = DependencyContainerMock()
        super.setUp()
    }
    
    func testRunMainFlowDoesNotRunMainFlowWhileWorkTimesControllerIsNil() {
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
        self.dependencyContainer.storyboardsManagerMock.controllerReturnValue[.workTimesList] = [.initial: WorkTimesListViewControllerMock()]
        //Act
        sut.start()
        //Assert
        XCTAssertFalse(sut.navigationController.children.isEmpty)
        XCTAssertNotNil(sut.navigationController.children.first as? WorkTimesListViewControllerable)
    }
}

// MARK: - Private
extension WorkTimesListCoordinatorTests {
    private func buildSUT() -> WorkTimesListCoordinator {
        return WorkTimesListCoordinator(dependencyContainer: self.dependencyContainer)
    }
    
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
