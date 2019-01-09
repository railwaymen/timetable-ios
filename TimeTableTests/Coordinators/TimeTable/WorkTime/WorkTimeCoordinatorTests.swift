//
//  WorkTimeCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeCoordinatorTests: XCTestCase {
 
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var apiClientMock: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var workTimeCoordinator: WorkTimesCoordinator!
    
    override func setUp() {
        storyboardsManagerMock = StoryboardsManagerMock()
        apiClientMock = ApiClientMock()
        errorHandlerMock = ErrorHandlerMock()
        workTimeCoordinator = WorkTimesCoordinator(window: nil,
                                                  storyboardsManager: storyboardsManagerMock,
                                                  apiClient: apiClientMock,
                                                  errorHandler: errorHandlerMock)
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
        storyboardsManagerMock.controller = WorkTimesViewController()
        //Act
        workTimeCoordinator.start()
        //Assert
        XCTAssertFalse(workTimeCoordinator.navigationController.children.isEmpty)
        XCTAssertNotNil(workTimeCoordinator.navigationController.children.first as? WorkTimesViewControlleralbe)
    }
}
