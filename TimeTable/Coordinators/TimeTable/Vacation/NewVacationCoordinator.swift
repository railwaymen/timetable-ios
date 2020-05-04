//
//  NewVacationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol NewVacationCoordinatorDelegate: class {
    func finishFlow(response: VacationDecoder?)
}

class NewVacationCoordinator: NavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    private var customFinishCompletion: ((VacationDecoder?) -> Void)?
    
    var root: UIViewController {
        return self.navigationController
    }
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parentViewController: UIViewController
    ) {
        self.dependencyContainer = dependencyContainer
        self.parentViewController = parentViewController
        super.init(window: dependencyContainer.window)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = false
        self.navigationController.navigationBar.tintColor = .tint
    }
    
    deinit {
        self.navigationController.setViewControllers([], animated: false)
    }
    
    // MARK: - Overridden
    func start(availableVacationDays: Int, finishHandler: ((VacationDecoder?) -> Void)?) {
        self.customFinishCompletion = finishHandler
        super.start()
        self.runMainFlow(availableVacationDays: availableVacationDays)
    }
    
    func finish(response: VacationDecoder?) {
        self.customFinishCompletion?(response)
        super.finish()
    }
    
    override func finish() {
        self.customFinishCompletion?(nil)
        super.finish()
    }
}

// MARK: - NewVacationCoordinatorDelegate
extension NewVacationCoordinator: NewVacationCoordinatorDelegate {
    func finishFlow(response: VacationDecoder?) {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish(response: response)
        }
    }
}

// MARK: - Private
extension NewVacationCoordinator {
    private func runMainFlow(availableVacationDays: Int) {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.newVacation()
            let viewModel = NewVacationViewModel(
                userInterface: controller,
                apiClient: apiClient,
                errorHandler: self.dependencyContainer.errorHandler,
                notificationCenter: self.dependencyContainer.notificationCenter,
                availableVacationDays: availableVacationDays,
                coordinator: self)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
            self.parentViewController?.present(self.navigationController, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
