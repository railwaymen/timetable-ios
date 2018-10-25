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
    
    //MARK: - CoordinatorType
    func testCoordinatorTypeExtension_normalStartRunsMethodStartFinishCompletionSucceed() {
        
        //Arrange
        let coordinator = ChildCoordinator(window: nil)
        
        //Act
        coordinator.start()
        
        //Assert
        XCTAssertTrue(coordinator.startWithFinishCompletionCalled)
        XCTAssertNil(coordinator.finishCompletion)
    }
    
    //MARK: - Coordinator
    func testCoordinator_startWithFinishCompletionSucceed() {
        
        //Arrange
        let coordinator = Coordinator(window: nil)
        
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
        let coordinator = Coordinator(window: nil)
        let childCoordinator = ChildCoordinator(window: nil)
        
        //Act
        coordinator.addChildCoordinator(child: childCoordinator)
        
        //Assert
        XCTAssertEqual(coordinator.children.count, 1)
    }
    
    func testCoordinator_addTwiceThisSameChildCoordinator() {
        
        //Arrange
        let coordinator = Coordinator(window: nil)
        let childCoordinator = ChildCoordinator(window: nil)
        
        //Act
        coordinator.addChildCoordinator(child: childCoordinator)
        coordinator.addChildCoordinator(child: childCoordinator)
        
        //Assert
        XCTAssertEqual(coordinator.children.count, 1)
    }
    
    func testCoordinator_removeChildCoordinator() throws {
        
        //Arrange
        let coordinator = Coordinator(window: nil)
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
}

private class ChildCoordinator: Coordinator {
    
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
