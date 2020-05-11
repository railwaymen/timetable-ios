//
//  KeyboardManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 08/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol KeyboardManagerObserverable {}

extension KeyboardManagerObserverable {
    var uniqueID: String {
        String(describing: Self.self)
    }
}

protocol KeyboardManagerable: class {
    func setKeyboardHeightChangeHandler(
        for observer: KeyboardManagerObserverable,
        handler: @escaping KeyboardManager.HeightChangeHandler)
    func removeHandler(for observer: KeyboardManagerObserverable)
}

class KeyboardManager {
    typealias HeightChangeHandler = (CGFloat) -> Void
    
    private weak var notificationCenter: NotificationCenterType?
    private var handlers: [String: HeightChangeHandler] = [:]
    
    // MARK: - Initialization
    init(notificationCenter: NotificationCenterType = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
        
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter?.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func keyboardWillChangeFrame(notification: Notification) {
        guard let keyboardHeight = self.getKeyboardHeight(from: notification) else { return }
        self.notifyObservers(keyboardHeight: keyboardHeight)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardHeight = self.getKeyboardHeight(from: notification) else { return }
        self.notifyObservers(keyboardHeight: keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.notifyObservers(keyboardHeight: 0)
    }
    
    @objc func keyboardDidHide() {
        self.notifyObservers(keyboardHeight: 0)
    }
}

// MARK: - Structures
extension KeyboardManager {
    private struct NotificationSetup {
        let selector: Selector
        let name: NSNotification.Name
    }
}

// MARK: - KeyboardManagerable
extension KeyboardManager: KeyboardManagerable {
    func setKeyboardHeightChangeHandler(
        for observer: KeyboardManagerObserverable,
        handler: @escaping HeightChangeHandler
    ) {
        self.handlers[observer.uniqueID] = handler
    }
    
    func removeHandler(for observer: KeyboardManagerObserverable) {
        self.handlers.removeValue(forKey: observer.uniqueID)
    }
}

// MARK: - Private
extension KeyboardManager {
    private func setUpNotifications() {
        let notificationsConfiguration: [NotificationSetup] = [
            .init(selector: #selector(self.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification),
            .init(selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification),
            .init(selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification),
            .init(selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardDidHideNotification)
        ]
        notificationsConfiguration.forEach { config in
            self.notificationCenter?.addObserver(
                self,
                selector: config.selector,
                name: config.name,
                object: nil)
        }
    }
    
    private func getKeyboardHeight(from notification: Notification) -> CGFloat? {
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return userInfo?.cgRectValue.size.height
    }
    
    private func notifyObservers(keyboardHeight: CGFloat) {
        self.handlers.values.forEach { handler in
            handler(keyboardHeight)
        }
    }
}
