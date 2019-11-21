//
//  BaseNavigationCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class BaseNavigationCoordinatorTests: XCTestCase {
    private var messagePresenterMock: MessagePresenterMock!
    
    override func setUp() {
        super.setUp()
        self.messagePresenterMock = MessagePresenterMock()
    }

    func testOverriddenInitialization() {
        //Arrange
        let window = UIWindow(frame: .zero)
        //Act
        let sut = BaseNavigationCoordinator(window: window,
                                            messagePresenter: self.messagePresenterMock)
        //Assert
        XCTAssertNil(window.rootViewController as? UINavigationController)
        XCTAssertNotNil(sut.navigationController)
    }
    
    func testCustomInitialization() {
        //Arrange
        let window = UIWindow(frame: .zero)
        let navigationController = UINavigationController()
        //Act
        let sut = BaseNavigationCoordinator(window: window,
                                            navigationController: navigationController,
                                            messagePresenter: self.messagePresenterMock)
        //Assert
        XCTAssertNil(window.rootViewController)
        XCTAssertEqual(sut.navigationController, navigationController)
    }
}
