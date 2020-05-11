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
    private var notificationCenter: NotificationCenterMock!
    
    override func setUp() {
        super.setUp()
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
        let observer = ObserverMock()
        sut.addKeyboardHeightChange(observer: observer)
        //Act
        sut.keyboardWillChangeFrame(notification: notification)
        //Assert
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 0)
    }
    
    func testKeyboardWillChangeFrame_withKeyboardHeight_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let observer = ObserverMock()
        sut.addKeyboardHeightChange(observer: observer)
        //Act
        sut.keyboardWillChangeFrame(notification: notification)
        //Assert
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, keyboardHeight)
    }
    
    func testKeyboardWillChangeFrame_withKeyboardHeight_notifiesMultipleObservers() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let observers = (0..<20).map { _ in ObserverMock() }
        observers.forEach { sut.addKeyboardHeightChange(observer: $0) }
        //Act
        sut.keyboardWillChangeFrame(notification: notification)
        //Assert
        observers.forEach { observer in
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, keyboardHeight)
        }
    }
}

// MARK: - keyboardDidShow(notification:)
extension KeyboardManagerTests {
    func testKeyboardDidShow_withoutKeyboardHeight_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let notification = self.notificationWithoutKeyboardHeight()
        let observer = ObserverMock()
        sut.addKeyboardHeightChange(observer: observer)
        //Act
        sut.keyboardDidShow(notification: notification)
        //Assert
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 0)
    }
    
    func testKeyboardDidShow_withKeyboardHeight_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let observer = ObserverMock()
        sut.addKeyboardHeightChange(observer: observer)
        //Act
        sut.keyboardDidShow(notification: notification)
        //Assert
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, keyboardHeight)
    }
    
    func testKeyboardDidShow_withKeyboardHeight_notifiesMultipleObservers() {
        //Arrange
        let sut = self.buildSUT()
        let keyboardHeight: CGFloat = 100
        let notification = self.notification(withKeyboardHeight: keyboardHeight)
        let observers = (0..<20).map { _ in ObserverMock() }
        observers.forEach { sut.addKeyboardHeightChange(observer: $0) }
        //Act
        sut.keyboardDidShow(notification: notification)
        //Assert
        observers.forEach { observer in
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, keyboardHeight)
        }
    }
}

// MARK: - keyboardWillHide()
extension KeyboardManagerTests {
    func testKeyboardWillHide_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let observer = ObserverMock()
        sut.addKeyboardHeightChange(observer: observer)
        //Act
        sut.keyboardWillHide()
        //Assert
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, 0)
    }
    
    func testKeyboardWillHide_notifiesMultipleObservers() {
        //Arrange
        let sut = self.buildSUT()
        let observers = (0..<20).map { _ in ObserverMock() }
        observers.forEach { sut.addKeyboardHeightChange(observer: $0) }
        //Act
        sut.keyboardWillHide()
        //Assert
        observers.forEach { observer in
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, 0)
        }
    }
}

// MARK: - keyboardDidHide()
extension KeyboardManagerTests {
    func testKeyboardDidHide_notifiesOneObserver() {
        //Arrange
        let sut = self.buildSUT()
        let observer = ObserverMock()
        sut.addKeyboardHeightChange(observer: observer)
        //Act
        sut.keyboardDidHide()
        //Assert
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
        XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, 0)
    }
    
    func testKeyboardDidHide_notifiesMultipleObservers() {
        //Arrange
        let sut = self.buildSUT()
        let observers = (0..<20).map { _ in ObserverMock() }
        observers.forEach { sut.addKeyboardHeightChange(observer: $0) }
        //Act
        sut.keyboardDidHide()
        //Assert
        observers.forEach { observer in
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.count, 1)
            XCTAssertEqual(observer.keyboardHeightDidChangeParams.last?.keyboardHeight, 0)
        }
    }
}

// MARK: - addKeyboardHeightChange(observer:)
extension KeyboardManagerTests {
    func testAddKeyboardHeightChangeObserver_keyboardDidHide_addsObserverOnlyOnce() {
        //Arrange
        let sut = self.buildSUT()
        let firstObserver = ObserverMock()
        let secondObserver = ObserverMock()
        //Act
        sut.addKeyboardHeightChange(observer: firstObserver)
        sut.addKeyboardHeightChange(observer: firstObserver)
        sut.addKeyboardHeightChange(observer: secondObserver)
        sut.addKeyboardHeightChange(observer: firstObserver)
        //Assert
        sut.keyboardDidHide()
        XCTAssertEqual(firstObserver.keyboardHeightDidChangeParams.count, 1)
        XCTAssertEqual(secondObserver.keyboardHeightDidChangeParams.count, 1)
    }
}

// MARK: - remove(observer:)
extension KeyboardManagerTests {
    func testRemoveObserver_keyboardDidHide_doesNotNotify() {
        //Arrange
        let sut = self.buildSUT()
        let firstObserver = ObserverMock()
        let secondObserver = ObserverMock()
        sut.addKeyboardHeightChange(observer: firstObserver)
        sut.addKeyboardHeightChange(observer: secondObserver)
        //Act
        sut.remove(observer: firstObserver)
        //Assert
        sut.keyboardDidHide()
        XCTAssertEqual(firstObserver.keyboardHeightDidChangeParams.count, 0)
        XCTAssertEqual(secondObserver.keyboardHeightDidChangeParams.count, 1)
    }
}

// MARK: - Private
extension KeyboardManagerTests {
    private func buildSUT() -> KeyboardManager {
        KeyboardManager(notificationCenter: self.notificationCenter)
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
private class ObserverMock: KeyboardManagerObserverable {
    private(set) var keyboardHeightDidChangeParams: [KeyboardHeightDidChangeParams] = []
    struct KeyboardHeightDidChangeParams {
        let keyboardHeight: CGFloat
    }
    
    func keyboardHeightDidChange(to keyboardHeight: CGFloat) {
        self.keyboardHeightDidChangeParams.append(KeyboardHeightDidChangeParams(keyboardHeight: keyboardHeight))
    }
}
