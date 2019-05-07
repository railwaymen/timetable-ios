//
//  TimeTableCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 24/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimeTableCoordinatorTests: XCTestCase {
    
    private var windowMock: UIWindow!
    private var storyboardsManagerMock: StoryboardsManagerMock!
    private var apiClientMock: ApiClientMock!
    private var accessServiceMock: AccessServiceMock!
    private var coreDataStackMock: CoreDataStackUserMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var coordinator: TimeTableTabCoordinator!
    private var messagePresenterMock: MessagePresenterMock!
    
    override func setUp() {
        self.windowMock = UIWindow()
        self.storyboardsManagerMock = StoryboardsManagerMock()
        self.apiClientMock = ApiClientMock()
        self.accessServiceMock = AccessServiceMock()
        self.coreDataStackMock = CoreDataStackUserMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.messagePresenterMock = MessagePresenterMock()
        
        self.coordinator = TimeTableTabCoordinator(window: self.windowMock,
                                                   messagePresenter: self.messagePresenterMock,
                                                   storyboardsManager: self.storyboardsManagerMock,
                                                   apiClient: self.apiClientMock,
                                                   accessService: self.accessServiceMock,
                                                   coreDataStack: self.coreDataStackMock,
                                                   errorHandler: self.errorHandlerMock)
        super.setUp()
    }

    func testCountOfChildrensOnStart() {
        //Arrange
        //Act
        coordinator.start(finishCompletion: {})
        //Assert
        XCTAssertEqual(coordinator.children.count, 3)
    }
    
    func testFinishCalled() {
        //Arrange
        coordinator.start(finishCompletion: {})
        //Act
        coordinator.finish()
        //Assert
        XCTAssertEqual(coordinator.children.count, 0)
    }
}
