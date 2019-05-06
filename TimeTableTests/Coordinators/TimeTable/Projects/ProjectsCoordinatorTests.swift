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
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var apiClientMock: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var projectsCoordinator: ProjectsCoordinator!
    private var messagePresenterMock: MessagePresenterMock!
    
    override func setUp() {
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.apiClientMock = ApiClientMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.messagePresenterMock = MessagePresenterMock()
        self.projectsCoordinator = ProjectsCoordinator(window: nil,
                                                       messagePresenter: self.messagePresenterMock,
                                                       storyboardsManager: self.storyboardsManagerMock,
                                                       apiClient: self.apiClientMock,
                                                       errorHandler: self.errorHandlerMock)
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
        storyboardsManagerMock.projectsController = ProjectsViewController()
        //Act
        projectsCoordinator.start()
        //Assert
        XCTAssertFalse(projectsCoordinator.navigationController.children.isEmpty)
        XCTAssertNotNil(projectsCoordinator.navigationController.children.first as? ProjectsViewControllerable)
    }
}
