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
    private var messagePresenterMock: MessagePresenterMock!
    
    override func setUp() {
        super.setUp()
        self.messagePresenterMock = MessagePresenterMock()
    }
    
    // MARK: - CoordinatorType
    func testCoordinatorTypeExtension_normalStartRunsMethodStartFinishCompletionSucceed() {
        //Arrange
        let sut = ChildCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        //Act
        sut.start()
        //Assert
        XCTAssertTrue(sut.startWithFinishCompletionCalled)
        XCTAssertNil(sut.finishCompletion)
    }
    
    // MARK: - Coordinator
    func testCoordinator_startWithFinishCompletionSucceed() {
        //Arrange
        let sut = BaseCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        //Act
        sut.start {}
        //Assert
        XCTAssertNotNil(sut.finishCompletion)
    }
    
    func testCoordinator_finishMethod() {
        //Arrange
        let sut = ChildCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        sut.start {}
        //Act
        sut.finish()
        //Assert
        XCTAssertTrue(sut.finishCalled)
    }
    
    func testCoordinator_addChildCoordinatorMethod() {
        //Arrange
        let sut = BaseCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        //Act
        sut.addChildCoordinator(child: childCoordinator)
        //Assert
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testCoordinator_addTwiceThisSameChildCoordinator() {
        //Arrange
        let sut = BaseCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        //Act
        sut.addChildCoordinator(child: childCoordinator)
        sut.addChildCoordinator(child: childCoordinator)
        //Assert
        XCTAssertEqual(sut.children.count, 2)
    }
    
    func testCoordinator_removeChildCoordinatorWhileGivenParametersIsNil() throws {
        //Arrange
        let sut = BaseCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        sut.addChildCoordinator(child: childCoordinator)
        //Act
        XCTAssertEqual(sut.children.count, 1)
        let firstChildCoordinator = try sut.children.first.unwrap()
        XCTAssertEqual(firstChildCoordinator, childCoordinator)
        
        sut.removeChildCoordinator(child: nil)
        //Assert
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testCoordinator_removeChildCoordinator() throws {
        //Arrange
        let sut = BaseCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        let childCoordinator = ChildCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        sut.addChildCoordinator(child: childCoordinator)
        //Act
        XCTAssertEqual(sut.children.count, 1)
        let firstChildCoordinator = try sut.children.first.unwrap()
        XCTAssertEqual(firstChildCoordinator, childCoordinator)
        
        sut.removeChildCoordinator(child: childCoordinator)
        //Assert
        XCTAssertEqual(sut.children.count, 0)
    }
    
    func testPresentErrorDoesNotPresentAlertController() {
        //Arrange
        let sut = ChildCoordinator(
            window: nil,
            messagePresenter: self.messagePresenterMock)
        sut.start()
        let error = TestError(message: "error_message")
        //Act
        sut.present(error: error)
        //Assert
        XCTAssertNil(sut.window?.rootViewController?.children)
    }
    
    func testPresentUiErrorPresentAlertController() throws {
        //Arrange
        let window = UIWindow()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let sut = ChildCoordinator(
            window: window,
            messagePresenter: self.messagePresenterMock)
        sut.start()
        let error = UIError.cannotBeEmpty(.endsAtTextField)
        //Act
        sut.present(error: error)
        //Assert
        XCTAssertEqual(self.messagePresenterMock.presentAlertControllerParams.last?.message, error.localizedDescription)
    }
    
    func testPresentApiErrorPresentAlertController() throws {
        //Arrange
        let window = UIWindow()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let sut = ChildCoordinator(
            window: window,
            messagePresenter: self.messagePresenterMock)
        sut.start()
        let url = try URL(string: "www.example.com").unwrap()
        let error = ApiClientError(type: .invalidHost(url))
        //Act
        sut.present(error: error)
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
