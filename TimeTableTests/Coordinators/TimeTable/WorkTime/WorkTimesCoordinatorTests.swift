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
    
    override func setUp() {
        storyboardsManagerMock = StoryboardsManagerMock()
        apiClientMock = ApiClientMock()
        accessService = AccessServiceMock()
        errorHandlerMock = ErrorHandlerMock()
        workTimeCoordinator = WorkTimesCoordinator(window: nil,
                                                  storyboardsManager: storyboardsManagerMock,
                                                  apiClient: apiClientMock,
                                                  accessService: accessService,
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
        storyboardsManagerMock.workTimesController = WorkTimesViewController()
        //Act
        workTimeCoordinator.start()
        //Assert
        XCTAssertFalse(workTimeCoordinator.navigationController.children.isEmpty)
        XCTAssertNotNil(workTimeCoordinator.navigationController.children.first as? WorkTimesViewControlleralbe)
    }
    
    // MARK: - WorkTimesCoordinatorDelegate
    func testWorkTimesRequestedForNewWorkTimeViewWhileStoryboardsManagerReturendNil() {
        //Arrange
        let button = UIButton()
        //Act
        workTimeCoordinator.workTimesRequestedForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }
    
    func testWorkTimesRequestedForNewWorkTimeViewWhileStoryboardsManagerReturendInvalidController() {
        //Arrange
        let button = UIButton()
        storyboardsManagerMock.workTimeController = UIViewController()
        //Act
        workTimeCoordinator.workTimesRequestedForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }

    func testWorkTimesRequestedForNewWorkTimeViewSucceed() {
        //Arrange
        let button = UIButton()
        storyboardsManagerMock.workTimeController = WorkTimeController()
        //Act
        workTimeCoordinator.workTimesRequestedForNewWorkTimeView(sourceView: button)
        //Assert
        XCTAssertNil(workTimeCoordinator.root.children.last)
    }
}
