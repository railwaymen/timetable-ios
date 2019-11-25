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
    private weak var messagePresenter: MessagePresenterType?
    
    // MARK: - Initialization
    init(
        window: UIWindow?,
        messagePresenter: MessagePresenterType?
    ) {
        self.children = []
        self.window = window
        self.messagePresenter = messagePresenter
    }

    // MARK: - CoordinatorType
    func start(finishCompletion: (() -> Void)?) {
        self.finishCompletion = finishCompletion
    }

    func finish() {
        self.children.forEach { [weak self] in
            $0.finish()
            self?.removeChildCoordinator(child: $0)
        }
        self.finishCompletion?()
    }
    
    func addChildCoordinator(child: BaseCoordinator) {
        self.children.append(child)
    }
    
    func removeChildCoordinator(child: BaseCoordinator?) {
        guard let index = self.children.firstIndex(where: { $0 == child }) else { return }
        self.children.remove(at: index)
    }
    
    // MARK: - CoordinatorErrorPresenterType
    func present(error: Error) {
        if let uiError = error as? UIError {
            self.presentAlertController(withMessage: uiError.localizedDescription)
        } else if let apiError = error as? ApiClientError {
            self.presentAlertController(withMessage: apiError.type.localizedDescription)
        }
    }
}
 
// MARK: - Private
extension BaseCoordinator {
    private func presentAlertController(withMessage message: String) {
        self.messagePresenter?.presentAlertController(withMessage: message)
    }
}
