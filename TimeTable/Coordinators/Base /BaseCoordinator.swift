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
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?) {
        self.children = []
        self.window = window
        self.messagePresenter = messagePresenter
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
        self.messagePresenter?.presentAlertController(withMessage: message)
    }
}
