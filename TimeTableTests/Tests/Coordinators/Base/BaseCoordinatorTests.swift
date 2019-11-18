//
//  BaseCoordinatorTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class BaseCoordinatorTests: XCTestCase {
    private let timetout = 0.1
    private var messagePresenterMock: MessagePresenterMock!
    
    override func setUp() {
        self.messagePresenterMock = MessagePresenterMock()
        super.setUp()
    }
    
    // MARK: - CoordinatorType
    func testCoordinatorTypeExtension_normalStartRunsMethodStartFinishCompletionSucceed() {
        //Arrange
        let coordinator = ChildCoordinator(window: nil,
                                           messagePresenter: self.messagePresenterMock)
        //Act
        coordinator.start()
        //Assert
        XCTAssertTrue(coordinator.startWithFinishCompletionCalled)
        XCTAssertNil(coordinator.finishCompletion)
    }
    
    // MARK: - Coordinator
    func testCoordinator_startWithFinishCompletionSucceed() {
        //Arrange
        let coordinator = BaseCoordinator(window: nil,
                                          messagePresenter: self.messagePresenterMock)
        //Act
        coordinator.start(finishCompletion: { Void() })
        //Assert
        XCTAssertNotNil(coordinator.finishCompletion)
    }
    
    func testCoordinator_finishMethod() {
        //Arrange
        let coordinator = ChildCoordinator(window: nil,
                                           messagePresenter: self.messagePresenterMock)
        coordinator.start(finishCompletion: { Void() })
        //Act
        coordinator.finish()
        //Assert
        XCTAssertTrue(coordinator.finishCalled)
    }
    
    func testCoordinator_addChildCoordinatorMethod() {
        //Arrange
        let coordinator = BaseCoordinator(window: nil,
                                          messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(window: nil,
                                                messagePresenter: self.messagePresenterMock)
        //Act
        coordinator.addChildCoordinator(child: childCoordinator)
        //Assert
        XCTAssertEqual(coordinator.children.count, 1)
    }
    
    func testCoordinator_addTwiceThisSameChildCoordinator() {
        //Arrange
        let coordinator = BaseCoordinator(window: nil,
                                          messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(window: nil,
                                                messagePresenter: self.messagePresenterMock)
        //Act
        coordinator.addChildCoordinator(child: childCoordinator)
        coordinator.addChildCoordinator(child: childCoordinator)
        //Assert
        XCTAssertEqual(coordinator.children.count, 2)
    }
    
    func testCoordinator_removeChildCoordinatorWhileGivenParametersIsNil() throws {
        //Arrange
        let coordinator = BaseCoordinator(window: nil,
                                          messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(window: nil,
                                                messagePresenter: self.messagePresenterMock)
        coordinator.addChildCoordinator(child: childCoordinator)
        //Act
        XCTAssertEqual(coordinator.children.count, 1)
        let firstChildCoordinator = try coordinator.children.first.unwrap()
        XCTAssertEqual(firstChildCoordinator, childCoordinator)
        
        coordinator.removeChildCoordinator(child: nil)
        //Assert
        XCTAssertEqual(coordinator.children.count, 1)
    }
    
    func testCoordinator_removeChildCoordinator() throws {
        //Arrange
        let coordinator = BaseCoordinator(window: nil,
                                          messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(window: nil,
                                                messagePresenter: self.messagePresenterMock)
        coordinator.addChildCoordinator(child: childCoordinator)
        //Act
        XCTAssertEqual(coordinator.children.count, 1)
        let firstChildCoordinator = try coordinator.children.first.unwrap()
        XCTAssertEqual(firstChildCoordinator, childCoordinator)
        
        coordinator.removeChildCoordinator(child: childCoordinator)
        //Assert
        XCTAssertEqual(coordinator.children.count, 0)
    }
    
    func testPresentErrorDoesNotPresentAlertController() {
        //Arrange
        let coordinator = ChildCoordinator(window: nil,
                                           messagePresenter: self.messagePresenterMock)
        coordinator.start()
        let error = TestError(message: "error_message")
        //Act
        coordinator.present(error: error)
        //Assert
        XCTAssertNil(coordinator.window?.rootViewController?.children)
    }
    
    func testPresentUiErrorPresentAlertController() throws {
        //Arrange
        let window = UIWindow()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let coordinator = ChildCoordinator(window: window,
                                           messagePresenter: self.messagePresenterMock)
        coordinator.start()
        let error = UIError.cannotBeEmpty(.endsAtTextField)
        //Act
        coordinator.present(error: error)
        //Assert
        XCTAssertEqual(self.messagePresenterMock.presentAlertControllerParams.last?.message, error.localizedDescription)
    }
    
    func testPresentApiErrorPresentAlertController() throws {
        //Arrange
        let window = UIWindow()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let coordinator = ChildCoordinator(window: window,
                                           messagePresenter: self.messagePresenterMock)
        coordinator.start()
        let url = try URL(string: "www.example.com").unwrap()
        let error = ApiClientError(type: .invalidHost(url))
        //Act
        coordinator.present(error: error)
        //Assert
        XCTAssertEqual(self.messagePresenterMock.presentAlertControllerParams.last?.message, error.type.localizedDescription)
    }
}

// MARK: - Private structures
private class ChildCoordinator: BaseCoordinator {
    
    private(set) var startWithFinishCompletionCalled: Bool = false
    private(set) var finishCalled: Bool = false
    
    override func start(finishCompletion: (() -> Void)?) {
        self.finishCompletion = finishCompletion
        self.startWithFinishCompletionCalled = true
        super.start(finishCompletion: finishCompletion)
    }
    
    override func finish() {
        self.finishCalled = true
        super.finish()
    }
}
