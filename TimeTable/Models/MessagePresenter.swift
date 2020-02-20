//
//  MessagePresenter.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 03/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

struct ButtonConfig {
    let title: String
    let style: UIAlertAction.Style
    let action: (() -> Void)?
}

protocol MessagePresenterType: class {
    func presentAlertController(withMessage message: String)
    func requestDecision(title: String?, message: String?, cancelButtonConfig: ButtonConfig, confirmButtonConfig: ButtonConfig)
}

class MessagePresenter {
    private var window: UIWindow?
    
    // MARK: - Initialization
    init(window: UIWindow?) {
        self.window = window
    }
}

// MARK: - MessagePresenterType
extension MessagePresenter: MessagePresenterType {
    func presentAlertController(withMessage message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [unowned alert] _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        alert.view.tintColor = .tint
        self.present(alert)
    }
    
    func requestDecision(title: String?, message: String?, cancelButtonConfig: ButtonConfig, confirmButtonConfig: ButtonConfig) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButtonConfig.title, style: cancelButtonConfig.style) { [unowned alert] _ in
            alert.dismiss(animated: true) {
                cancelButtonConfig.action?()
            }
        }
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: confirmButtonConfig.title, style: confirmButtonConfig.style) { [unowned alert] _ in
            alert.dismiss(animated: true) {
                confirmButtonConfig.action?()
            }
        }
        alert.addAction(confirmAction)
        alert.view.tintColor = .tint
        self.present(alert)
    }
}

// MARK: - Private
extension MessagePresenter {
    private func present(_ viewController: UIViewController) {
        self.window?.rootViewController?.topController().present(viewController, animated: true)
    }
}
