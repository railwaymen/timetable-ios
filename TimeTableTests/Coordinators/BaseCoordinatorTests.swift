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
    
    // MARK: - CoordinatorType
    func testCoordinatorTypeExtension_normalStartRunsMethodStartFinishCompletionSucceed() {
        
        //Arrange
        let coordinator = ChildCoordinator(window: nil)
        
        //Act
        coordinator.start()
        
        //Assert
        XCTAssertTrue(coordinator.startWithFinishCompletionCalled)
        XCTAssertNil(coordinator.finishCompletion)
    }
    
    // MARK: - Coordinator
    func testCoordinator_startWithFinishCompletionSucceed() {
        
        //Arrange
        let coordinator = BaseCoordinator(window: nil)
        
        //Act
        coordinator.start(finishCompletion: { Void() })
        
        //Assert
        XCTAssertNotNil(coordinator.finishCompletion)
    }
    
    func testCoordinator_finishMethod() {
        
        //Arrange
        let coordinator = ChildCoordinator(window: nil)
        coordinator.start(finishCompletion: { Void() })
        
        //Act
        coordinator.finish()
        
        //Assert
        XCTAssertTrue(coordinator.finishCalled)
    }
    
    func testCoordinator_addChildCoordinatorMethod() {
        
        //Arrange
        let coordinator = BaseCoordinator(window: nil)
        let childCoordinator = ChildCoordinator(window: nil)
        
        //Act
        coordinator.addChildCoordinator(child: childCoordinator)
        
        //Assert
        XCTAssertEqual(coordinator.children.count, 1)
    }
    
    func testCoordinator_addTwiceThisSameChildCoordinator() {
        
        //Arrange
        let coordinator = BaseCoordinator(window: nil)
        let childCoordinator = ChildCoordinator(window: nil)
        
        //Act
        coordinator.addChildCoordinator(child: childCoordinator)
        coordinator.addChildCoordinator(child: childCoordinator)
        
        //Assert
        XCTAssertEqual(coordinator.children.count, 1)
    }
    
    func testCoordinator_removeChildCoordinator() throws {
        
        //Arrange
        let coordinator = BaseCoordinator(window: nil)
        let childCoordinator = ChildCoordinator(window: nil)
        
        coordinator.addChildCoordinator(child: childCoordinator)
        
        //Act
        XCTAssertEqual(coordinator.children.count, 1)
        let firstChildCoordinator = try coordinator.children.first.unwrap()
        XCTAssertEqual(firstChildCoordinator.key, childCoordinator)
        
        coordinator.removeChildCoordinator(child: childCoordinator)
        //Assert
        XCTAssertEqual(coordinator.children.count, 0)
    }
    
    func testPresentErrorDoesNotPresentAlertController() {
        //Arrange
        let coordinator = ChildCoordinator(window: nil)
        coordinator.start()
        let error = TestError(messsage: "error_message")
        //Act
        coordinator.present(error: error)
        //Assert
        XCTAssertNil(coordinator.window?.rootViewController?.children)
    }
    
    func testPresentErrorPresentAlertController() throws {
        //Arrange
        let window = UIWindow()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let coordinator = ChildCoordinator(window: window)
        coordinator.start()
        let error = UIError.invalidFormat(.serverAddressTextField)
        //Act
        coordinator.present(error: error)
        //Assert
        let childController = try navigationController.children.first.unwrap()
        XCTAssertNotNil(childController.presentedViewController as? UIAlertController)
    }
}

private class ChildCoordinator: BaseCoordinator {
    
    private(set) var startWithFinishCompletionCalled: Bool = false
    private(set) var finishCalled: Bool = false
    
    override func start(finishCompletion: (() -> Void)?) {
        self.finishCompletion = finishCompletion
        startWithFinishCompletionCalled = true
        super.start(finishCompletion: finishCompletion)
    }
    
    override func finish() {
        finishCalled = true
        super.finish()
    }
}

private struct TestError: Error {
    let messsage: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.messsage == rhs.messsage
    }
}
