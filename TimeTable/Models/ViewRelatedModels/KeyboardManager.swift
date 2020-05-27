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
    var currentState: KeyboardManager.KeyboardState { get }
    func setKeyboardStateChangeHandler(
        for observer: KeyboardManagerObserverable,
        handler: @escaping KeyboardManager.StateChangeHandler)
    func removeHandler(for observer: KeyboardManagerObserverable)
}

class KeyboardManager {
    typealias StateChangeHandler = (KeyboardState) -> Void
    
    private weak var notificationCenter: NotificationCenterType?
    private var handlers: [String: StateChangeHandler] = [:]
    private var currentStateForHandler: [String: KeyboardState] = [:]
    private(set) var currentState: KeyboardState = .hidden {
        didSet {
            self.notifyObservers(state: self.currentState)
        }
    }
    
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
        guard let keyboardState = self.getKeyboardState(from: notification) else { return }
        self.currentState = keyboardState
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardState = self.getKeyboardState(from: notification) else { return }
        self.currentState = keyboardState
    }
    
    @objc func keyboardWillHide() {
        self.currentState = .hidden
    }
    
    @objc func keyboardDidHide() {
        self.currentState = .hidden
    }
}

// MARK: - Structures
extension KeyboardManager {
    enum KeyboardState: Equatable {
        case shown(height: CGFloat)
        case hidden
        
        init(height: CGFloat) {
            self = height == 0 ? .hidden : .shown(height: height)
        }
        
        var keyboardHeight: CGFloat {
            switch self {
            case .hidden:
                return 0
            case let .shown(height):
                return height
            }
        }
    }
    
    private struct NotificationSetup {
        let selector: Selector
        let name: NSNotification.Name
    }
}

// MARK: - KeyboardManagerable
extension KeyboardManager: KeyboardManagerable {
    func setKeyboardStateChangeHandler(
        for observer: KeyboardManagerObserverable,
        handler: @escaping StateChangeHandler
    ) {
        self.handlers[observer.uniqueID] = handler
        self.currentStateForHandler[observer.uniqueID] = .hidden
    }
    
    func removeHandler(for observer: KeyboardManagerObserverable) {
        self.handlers.removeValue(forKey: observer.uniqueID)
        self.currentStateForHandler.removeValue(forKey: observer.uniqueID)
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
    
    private func getKeyboardState(from notification: Notification) -> KeyboardState? {
        let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let height = userInfo?.cgRectValue.size.height else { return nil }
        return KeyboardState(height: height)
    }
    
    private func notifyObservers(state: KeyboardState) {
        self.handlers.keys.forEach { key in
            guard self.currentStateForHandler[key] != state else { return }
            self.handlers[key]?(state)
            self.currentStateForHandler[key] = state
        }
    }
}
