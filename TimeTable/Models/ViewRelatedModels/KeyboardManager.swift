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
    
    private let dispatchQueueManager: DispatchQueueManagerType
    private weak var notificationCenter: NotificationCenterType?
    private var handlers: [String: StateChangeHandler] = [:]
    private var currentStateForHandler: [String: KeyboardState] = [:]
    
    private var lastKeyboardChangeInfo: KeyboardChangeInformation {
        didSet {
            let info = self.lastKeyboardChangeInfo
            let delay: TimeInterval = 0.05
            let dispatchDelay = DispatchTimeInterval(delay)
            self.dispatchQueueManager.performOnMainThreadAsyncAfter(deadline: .now() + dispatchDelay) { [weak self] in
                guard let self = self else { return }
                guard info == self.lastKeyboardChangeInfo else { return }
                let duration = info.animationDuration - delay
                let curve = info.animationCurve
                let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
                    self.notifyObservers(state: info.state)
                }
                animator.startAnimation()
            }
        }
    }
    
    var currentState: KeyboardState {
        self.lastKeyboardChangeInfo.state
    }
    
    // MARK: - Initialization
    init(
        dispatchQueueManager: DispatchQueueManagerType,
        notificationCenter: NotificationCenterType = NotificationCenter.default
    ) {
        self.dispatchQueueManager = dispatchQueueManager
        self.notificationCenter = notificationCenter
        self.lastKeyboardChangeInfo = KeyboardChangeInformation()
        
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter?.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func keyboardWillChangeFrame(notification: Notification) {
        self.lastKeyboardChangeInfo = KeyboardChangeInformation(notification: notification)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        self.lastKeyboardChangeInfo = KeyboardChangeInformation(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.lastKeyboardChangeInfo = KeyboardChangeInformation(notification: notification, state: .hidden)
    }
    
    @objc func keyboardDidHide(notification: Notification) {
        self.lastKeyboardChangeInfo = KeyboardChangeInformation(notification: notification, state: .hidden)
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
    
    private struct KeyboardChangeInformation: Equatable {
        private static let defaultState: KeyboardState = .hidden
        private static let defaultAnimationDuration: TimeInterval = 0
        private static let defaultAnimationCurve: UIView.AnimationCurve = .keyboard
        
        private static func getKeyboardState(userInfo: [AnyHashable: Any]?) -> KeyboardState? {
            let endFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            guard let height = endFrame?.cgRectValue.size.height else { return nil }
            return KeyboardState(height: height)
        }
        
        private static func getKeyboardAnimationCurve(userInfo: [AnyHashable: Any]?) -> UIView.AnimationCurve? {
            guard let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else {
                return nil
            }
            return UIView.AnimationCurve(rawValue: index)
        }
        
        private static func getKeyboardAnimationDuration(userInfo: [AnyHashable: Any]?) -> TimeInterval? {
            (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        }
        
        // MARK: - Instance
        var state: KeyboardState
        var animationDuration: TimeInterval
        var animationCurve: UIView.AnimationCurve
        
        init(notification: Notification? = nil, state: KeyboardState? = nil) {
            let userInfo = notification?.userInfo
            self.state = state ?? Self.getKeyboardState(userInfo: userInfo) ?? Self.defaultState
            self.animationDuration = Self.getKeyboardAnimationDuration(userInfo: userInfo) ?? Self.defaultAnimationDuration
            self.animationCurve = Self.getKeyboardAnimationCurve(userInfo: userInfo) ?? Self.defaultAnimationCurve
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
    
    private func notifyObservers(state: KeyboardState) {
        self.handlers.keys.forEach { key in
            guard self.currentStateForHandler[key] != state else { return }
            self.handlers[key]?(state)
            self.currentStateForHandler[key] = state
        }
    }
}
