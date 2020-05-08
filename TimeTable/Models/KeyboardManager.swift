//
//  KeyboardManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 08/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol KeyboardManagerObserverable: class {
    func keyboardHeightDidChange(to keyboardHeight: CGFloat)
}

protocol KeyboardManagerable: class {
    
    /// Registers observer for keyboard height changes - needs removing to release the observer.
    ///
    /// - Parameters:
    ///   - observer:
    ///     An observer of keyboard height.
    ///     It should be released as soon as it isn't needed because of a strong reference.
    func addKeyboardHeightChange(observer: KeyboardManagerObserverable)
    
    /// Removes observer for keyboard height changes. Need to be called before object can be released.
    ///
    /// - Parameters:
    ///   - observer: An observer of keyboard height.
    func remove(observer: KeyboardManagerObserverable)
}

class KeyboardManager {
    private let notificationCenter: NotificationCenterType
    private var observers: [KeyboardManagerObserverable] = []
    
    // MARK: - Initialization
    init(notificationCenter: NotificationCenterType = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
        
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
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
    func addKeyboardHeightChange(observer: KeyboardManagerObserverable) {
        self.observers.append(observer)
    }
    
    func remove(observer: KeyboardManagerObserverable) {
        self.observers.removeAll { $0 === observer }
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
            self.notificationCenter.addObserver(
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
        self.observers.forEach {
            $0.keyboardHeightDidChange(to: keyboardHeight)
        }
    }
}
