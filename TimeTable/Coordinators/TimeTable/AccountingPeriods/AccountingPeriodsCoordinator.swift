//
//  AccountingPeriodsCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol AccountingPeriodsCoordinatorViewModelInterface: class {
    func configure(_ errorView: ErrorViewable, refreshHandler: (() -> Void)?) -> ErrorViewModelParentType
}

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
extension AccountingPeriodsCoordinator: AccountingPeriodsCoordinatorViewModelInterface {
    func configure(_ errorView: ErrorViewable, refreshHandler: (() -> Void)?) -> ErrorViewModelParentType {
        let viewModel = ErrorViewModel(
            userInterface: errorView,
            localizedError: UIError.genericError,
            actionHandler: refreshHandler)
        errorView.configure(viewModel: viewModel)
        return viewModel
    }
}

// MARK: - Private
extension AccountingPeriodsCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.requireApiClient() else { return }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.accountingPeriods()
            let viewModel = AccountingPeriodsViewModel(
                userInterface: controller,
                coordinator: self,
                apiClient: apiClient,
                errorHandler: self.dependencyContainer.errorHandler)
            controller.configure(viewModel: viewModel)
            self.navigationController.pushViewController(controller, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
