//
//  MessagePresenter.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 03/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol MessagePresenterType: class {
    func presentAlertController(withMessage message: String)
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
        alert.view.tintColor = .crimson
        if let presentedViewController = self.window?.rootViewController?.presentedViewController {
            presentedViewController.present(alert, animated: true)
        } else {
            self.window?.rootViewController?.present(alert, animated: true)
        }
    }
}
