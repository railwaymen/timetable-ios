//
//  AccountingPeriodsCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol AccountingPeriodsCoordinatorViewModelInterface: class {}

class AccountingPeriodsCoordinator: NavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    
    // MARK: - Initialization
    init(
        navigationController: UINavigationController,
        dependencyContainer: DependencyContainerType
    ) {
        self.dependencyContainer = dependencyContainer
        super.init(
            window: self.dependencyContainer.window,
            navigationController: navigationController)
    }
    
    // MARK: - Overridden
    override func start(finishHandler: FinishHandlerType?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
    }
}

// MARK: - AccountingPeriodsCoordinatorViewModelInterface
extension AccountingPeriodsCoordinator: AccountingPeriodsCoordinatorViewModelInterface {}

// MARK: - Private
extension AccountingPeriodsCoordinator {
    private func runMainFlow() {
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.accountingPeriods()
            let viewModel = AccountingPeriodsViewModel(
                userInterface: controller,
                coordinator: self)
            controller.configure(viewModel: viewModel)
            self.navigationController.pushViewController(controller, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
