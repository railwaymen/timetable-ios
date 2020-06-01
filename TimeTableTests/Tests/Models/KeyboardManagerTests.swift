//
//  KeyboardManagerTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class KeyboardManagerTests: XCTestCase {
    private var dispatchQueueManager: DispatchQueueManagerMock!
    private var notificationCenter: NotificationCenterMock!
    
    override func setUp() {
        super.setUp()
        self.dispatchQueueManager = DispatchQueueManagerMock(taskType: .performOnCurrentThread)
        self.notificationCenter = NotificationCenterMock()
    }
}

// MARK: - init()
extension KeyboardManagerTests {
    func testInit_setsUpNotifications() {
        //Act
        _ = self.buildSUT()
        //Assert
        XCTAssertEqual(self.notificationCenter.addObserverParams.count, 4)
        let notificationNames = self.notificationCenter.addObserverParams.map(\.name)
        XCTAssert(notificationNames.contains(UIResponder.keyboardWillChangeFrameNotification))
        XCTAssert(notificationNames.contains(UIResponder.keyboardDidShowNotification))
        XCTAssert(notificationNames.contains(UIResponder.keyboardWillHideNotification))
        XCTAssert(notificationNames.contains(UIResponder.keyboardDidHideNotification))
    }
}

// MARK: - keyboardWillChangeFrame(notification:)
extension KeyboardManagerTests {
    func testKeyboardWillChangeFrame_withoutKeyboardHeight_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let notification = self.notificationWithoutKeyboardHeight()
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        //Act
        sut.keyboardWillChangeFrame(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 0)
    }
    
    func testKeyboardWillChangeFrame_withKeyboardHeight_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        //Act
        sut.keyboardWillChangeFrame(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 1)
        XCTAssertEqual(handlerManager.handlerParams.last?.keyboardState, .shown(height: keyboardHeight))
    }

    func testKeyboardWillChangeFrame_withKeyboardHeight_notifiesTwoObservers() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let firstHandlerManager = KeyboardHandlerManager()
        firstHandlerManager.setHandler(in: sut, for: ObserverMock())
        let secondHandlerManager = KeyboardHandlerManager()
        secondHandlerManager.setHandler(in: sut, for: SecondObserverMock())
        //Act
        sut.keyboardWillChangeFrame(notification: notification)
        //Assert
        XCTAssertEqual(firstHandlerManager.handlerParams.count, 1)
        XCTAssertEqual(firstHandlerManager.handlerParams.last?.keyboardState, .shown(height: keyboardHeight))
        XCTAssertEqual(secondHandlerManager.handlerParams.count, 1)
        XCTAssertEqual(secondHandlerManager.handlerParams.last?.keyboardState, .shown(height: keyboardHeight))
    }
}

// MARK: - keyboardDidShow(notification:)
extension KeyboardManagerTests {
    func testKeyboardDidShow_withoutKeyboardHeight_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let notification = self.notificationWithoutKeyboardHeight()
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        //Act
        sut.keyboardDidShow(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 0)
    }

    func testKeyboardDidShow_withKeyboardHeight_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        //Act
        sut.keyboardDidShow(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 1)
        XCTAssertEqual(handlerManager.handlerParams.last?.keyboardState, .shown(height: keyboardHeight))
    }

    func testKeyboardDidShow_withKeyboardHeight_notifiesMultipleObservers() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let firstHandlerManager = KeyboardHandlerManager()
        firstHandlerManager.setHandler(in: sut, for: ObserverMock())
        let secondHandlerManager = KeyboardHandlerManager()
        secondHandlerManager.setHandler(in: sut, for: SecondObserverMock())
        //Act
        sut.keyboardDidShow(notification: notification)
        //Assert
        XCTAssertEqual(firstHandlerManager.handlerParams.count, 1)
        XCTAssertEqual(firstHandlerManager.handlerParams.last?.keyboardState, .shown(height: keyboardHeight))
        XCTAssertEqual(secondHandlerManager.handlerParams.count, 1)
        XCTAssertEqual(secondHandlerManager.handlerParams.last?.keyboardState, .shown(height: keyboardHeight))
    }
}

// MARK: - keyboardWillHide()
extension KeyboardManagerTests {
    func testKeyboardWillHide_withCurrentHiddenState_doesNotNotify() {
        //Arrange
        let sut = self.buildSUT()
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        let notification = self.notification(withKeyboardHeight: 100)
        //Act
        sut.keyboardWillHide(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 0)
    }
    
    func testKeyboardWillHide_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        sut.keyboardDidShow(notification: notification)
        //Act
        sut.keyboardWillHide(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 2)
        XCTAssertEqual(handlerManager.handlerParams.last?.keyboardState, .hidden)
    }

    func testKeyboardWillHide_notifiesMultipleObservers() {
        //Arrange
        let sut = self.buildSUT()
        let firstHandlerManager = KeyboardHandlerManager()
        firstHandlerManager.setHandler(in: sut, for: ObserverMock())
        let secondHandlerManager = KeyboardHandlerManager()
        secondHandlerManager.setHandler(in: sut, for: SecondObserverMock())
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        sut.keyboardDidShow(notification: notification)
        //Act
        sut.keyboardWillHide(notification: notification)
        //Assert
        XCTAssertEqual(firstHandlerManager.handlerParams.count, 2)
        XCTAssertEqual(firstHandlerManager.handlerParams.last?.keyboardState, .hidden)
        XCTAssertEqual(secondHandlerManager.handlerParams.count, 2)
        XCTAssertEqual(secondHandlerManager.handlerParams.last?.keyboardState, .hidden)
    }
}

// MARK: - keyboardDidHide()
extension KeyboardManagerTests {
    func testKeyboardDidHide_withCurrentHiddenState_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        let notification = self.notification(withKeyboardHeight: 100)
        //Act
        sut.keyboardDidHide(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 0)
    }

    func testKeyboardDidHide_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let handlerManager = KeyboardHandlerManager()
        handlerManager.setHandler(in: sut, for: ObserverMock())
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        sut.keyboardDidShow(notification: notification)
        //Act
        sut.keyboardDidHide(notification: notification)
        //Assert
        XCTAssertEqual(handlerManager.handlerParams.count, 2)
        XCTAssertEqual(handlerManager.handlerParams.last?.keyboardState, .hidden)
    }

    func testKeyboardDidHide_notifiesMultipleObservers() {
        //Arrange
        let sut = self.buildSUT()
        let firstHandlerManager = KeyboardHandlerManager()
        firstHandlerManager.setHandler(in: sut, for: ObserverMock())
        let secondHandlerManager = KeyboardHandlerManager()
        secondHandlerManager.setHandler(in: sut, for: SecondObserverMock())
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        sut.keyboardDidShow(notification: notification)
        //Act
        sut.keyboardDidHide(notification: notification)
        //Assert
        XCTAssertEqual(firstHandlerManager.handlerParams.count, 2)
        XCTAssertEqual(firstHandlerManager.handlerParams.last?.keyboardState, .hidden)
        XCTAssertEqual(secondHandlerManager.handlerParams.count, 2)
        XCTAssertEqual(secondHandlerManager.handlerParams.last?.keyboardState, .hidden)
    }
}

// MARK: - setKeyboardStateChangeHandler(for:handler:)
extension KeyboardManagerTests {
    func testSetKeyboardHeightChangeHandler_keyboardDidShow_overridesPreviousHandler() {
        //Arrange
        let sut = self.buildSUT()
        let firstHandlerManager = KeyboardHandlerManager()
        let secondHandlerManager = KeyboardHandlerManager()
        let thirdHandlerManager = KeyboardHandlerManager()
        //Act
        firstHandlerManager.setHandler(in: sut, for: ObserverMock())
        secondHandlerManager.setHandler(in: sut, for: SecondObserverMock())
        thirdHandlerManager.setHandler(in: sut, for: ObserverMock())
        //Assert
        let notification = self.notification(withKeyboardHeight: 100)
        sut.keyboardDidShow(notification: notification)
        XCTAssertEqual(firstHandlerManager.handlerParams.count, 0)
        XCTAssertEqual(secondHandlerManager.handlerParams.count, 1)
        XCTAssertEqual(thirdHandlerManager.handlerParams.count, 1)
    }
}

// MARK: - removeHandler(for:)
extension KeyboardManagerTests {
    func testRemoveObserver_keyboardDidShow_doesNotNotify() {
        //Arrange
        let sut = self.buildSUT()
        let firstHandlerManager = KeyboardHandlerManager()
        let secondHandlerManager = KeyboardHandlerManager()
        firstHandlerManager.setHandler(in: sut, for: ObserverMock())
        secondHandlerManager.setHandler(in: sut, for: SecondObserverMock())
        //Act
        sut.removeHandler(for: ObserverMock())
        //Assert
        let notification = self.notification(withKeyboardHeight: 100)
        sut.keyboardDidShow(notification: notification)
        XCTAssertEqual(firstHandlerManager.handlerParams.count, 0)
        XCTAssertEqual(secondHandlerManager.handlerParams.count, 1)
    }
}

// MARK: - Private
extension KeyboardManagerTests {
    private func buildSUT() -> KeyboardManager {
        KeyboardManager(
            dispatchQueueManager: self.dispatchQueueManager,
            notificationCenter: self.notificationCenter)
    }
    
    private func notification(withKeyboardHeight keyboardHeight: CGFloat) -> Notification {
        let rect = CGRect(x: 0, y: 0, width: 0, height: keyboardHeight)
        return Notification(
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            userInfo: [UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: rect)])
    }
    
    private func notificationWithoutKeyboardHeight() -> Notification {
        Notification(name: UIResponder.keyboardWillChangeFrameNotification)
    }
}

// MARK: - Structures
private class ObserverMock: KeyboardManagerObserverable {}
private class SecondObserverMock: KeyboardManagerObserverable {}

private class KeyboardHandlerManager {
    
    private(set) var handlerParams: [HandlerParams] = []
    struct HandlerParams {
        let keyboardState: KeyboardManager.KeyboardState
    }
    
    // MARK: - Internal
    func setHandler(in manager: KeyboardManager, for observer: KeyboardManagerObserverable) {
        manager.setKeyboardStateChangeHandler(for: observer) { [weak self] state in
            self?.handlerParams.append(HandlerParams(keyboardState: state))
        }
    }
}
