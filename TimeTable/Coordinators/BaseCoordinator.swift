//
//  BaseCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class BaseCoordinator: CoordinatorType, CoordinatorErrorPresenterType {
    
    var identifier: UUID = UUID()
    var children: [BaseCoordinator: Any]
    var window: UIWindow?
    var finishCompletion: (() -> Void)?
    
    // MARK: - Initialization
    init(window: UIWindow?) {
        self.identifier = UUID()
        self.children = [:]
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
        children[child] = child
    }
    
    func removeChildCoordinator(child: BaseCoordinator) {
        children[child] = nil
    }
    
    // MARK: - CoordinatorErrorPresenterType
    func present(error: Error) {
        if let uiError = error as? UIError {
            presentAllertController(withMessage: uiError.localizedDescription)
        } else if let apiError = error as? ApiError {
            presentAllertController(withMessage: apiError.localizedDescription)
        }
    }
    
    // MARK: - Private
    private func presentAllertController(withMessage message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [unowned alert] _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        DispatchQueue.main.async { [weak self] in
            self?.window?.rootViewController?.present(alert, animated: true)
        }
    }
}
