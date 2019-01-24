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
    
    override func setUp() {
        windowMock = UIWindow()
        storyboardsManagerMock = StoryboardsManagerMock()
        apiClientMock = ApiClientMock()
        accessServiceMock = AccessServiceMock()
        coreDataStackMock = CoreDataStackUserMock()
        errorHandlerMock = ErrorHandlerMock()
        
        coordinator = TimeTableTabCoordinator(window: windowMock,
                                              storyboardsManager: storyboardsManagerMock,
                                              apiClient: apiClientMock,
                                              accessService: accessServiceMock,
                                              coreDataStack: coreDataStackMock,
                                              errorHandler: errorHandlerMock)
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
