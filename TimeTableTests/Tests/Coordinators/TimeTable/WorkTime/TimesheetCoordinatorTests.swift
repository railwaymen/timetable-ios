//
//  TimesheetCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimesheetCoordinatorTests: XCTestCase {
    private var dependencyContainer: DependencyContainerMock!
    
    private var viewControllerBuilderMock: ViewControllerBuilderMock {
        self.dependencyContainer.viewControllerBuilderMock
    }
    
    override func setUp() {
        self.dependencyContainer = DependencyContainerMock()
        super.setUp()
    }
}

// MARK: - start(finishHandler:)
extension TimesheetCoordinatorTests {
    func testStart_viewControllerBuilderThrows_doesNotRunMainFlow() {
        //Arrange
        let sut = self.buildSUT()
        let error = "Error message"
        self.dependencyContainer.viewControllerBuilderMock.timesheetThrownError = error
        //Act
        sut.start()
        //Assert
        XCTAssertTrue(sut.navigationController.children.isEmpty)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.count, 1)
        XCTAssertEqual(self.dependencyContainer.errorHandlerMock.stopInDebugParams.last?.message, error)
    }
    
    func testRunMainFlowRunsMainFlow() {
        //Arrange
        let sut = self.buildSUT()
        self.viewControllerBuilderMock.timesheetReturnValue = TimesheetViewControllerMock()
        //Act
        sut.start()
        //Assert
        XCTAssertFalse(sut.navigationController.children.isEmpty)
        XCTAssertNotNil(sut.navigationController.children.first as? TimesheetViewControllerable)
    }
}

// MARK: - Private
extension TimesheetCoordinatorTests {
    private func buildSUT() -> TimesheetCoordinator {
        return TimesheetCoordinator(dependencyContainer: self.dependencyContainer)
    }
    
    private func createTask() -> TaskForm {
        return TaskForm(
            workTimeID: 1,
            project: nil,
            body: "body",
            urlString: "",
            day: Date(),
            startsAt: Date(),
            endsAt: Date().addingTimeInterval(3600),
            tag: .default)
    }
}
