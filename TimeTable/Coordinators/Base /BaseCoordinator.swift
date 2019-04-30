//
//  BaseCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class BaseCoordinator: CoordinatorType, CoordinatorErrorPresenterType {
    
    var children: [BaseCoordinator]
    var window: UIWindow?
    var finishCompletion: (() -> Void)?
    
    // MARK: - Initialization
    init(window: UIWindow?) {
        self.children = []
        self.window = window
    }

    // MARK: - CoordinatorType
    func start(finishCompletion: (() -> Void)?) {
        self.finishCompletion = finishCompletion
    }

    func finish() {
        finishCompletion?()
    }
    
    func addChildCoordinator(child: BaseCoordinator) {
        children.append(child)
    }
    
    func removeChildCoordinator(child: BaseCoordinator?) {
        guard let index = children.firstIndex(where: { $0 == child }) else { return }
        children.remove(at: index)
    }
    
    // MARK: - CoordinatorErrorPresenterType
    func present(error: Error) {
        if let uiError = error as? UIError {
            presentAlertController(withMessage: uiError.localizedDescription)
        } else if let apiError = error as? ApiClientError {
            presentAlertController(withMessage: apiError.type.localizedDescription)
        }
    }
    
    // MARK: - Private
    private func presentAlertController(withMessage message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [unowned alert] _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        DispatchQueue.main.async { [weak self] in
            if let presentedViewController = self?.window?.rootViewController?.presentedViewController {
                presentedViewController.present(alert, animated: true)
            } else {
                self?.window?.rootViewController?.present(alert, animated: true)
            }
        }
    }
}
