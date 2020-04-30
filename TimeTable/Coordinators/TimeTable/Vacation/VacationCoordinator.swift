//
//  VacationCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol VacationCoordinatorDelegate: class {
    func vacationRequestedForProfileView()
    func vacationRequestedForUsedDaysView(usedDays: VacationResponse.UsedVacationDays)
    func vacationRequestedForNewVacationForm(availableVacationDays: Int)
}

protocol UsedVacationCoordinatorDelegate: class {
    func usedVacationRequestToFinish()
}

class VacationCoordinator: NavigationCoordinator, TabBarChildCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        
        self.tabBarItem = UITabBarItem(
            title: R.string.localizable.vacation_title(),
            image: R.image.tab_bar_vacation_icon(),
            selectedImage: nil)
        super.init(window: dependencyContainer.window)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.navigationBar.tintColor = .tint
        self.root.tabBarItem = self.tabBarItem
    }
    
    // MARK: - Overridden
    override func start(finishHandler: (() -> Void)?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
    }
}

// MARK: - VacationCoordinatorDelegate
extension VacationCoordinator: VacationCoordinatorDelegate {
    func vacationRequestedForProfileView() {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        self.dependencyContainer.parentCoordinator?.showProfile(parentViewController: parentViewController)
    }
    
    func vacationRequestedForUsedDaysView(usedDays: VacationResponse.UsedVacationDays) {
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.usedVacation()
            let viewModel = UsedVacationViewModel(userInterface: controller, coordinator: self, usedDays: usedDays)
            controller.configure(viewModel: viewModel)
            self.navigationController.present(controller, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
    
    func vacationRequestedForNewVacationForm(availableVacationDays: Int) {
        self.runNewVacationFlow(availableVacationDays: availableVacationDays)
    }
}

// MARK: - UsedVacationCoordinatorDelegate
extension VacationCoordinator: UsedVacationCoordinatorDelegate {
    func usedVacationRequestToFinish() {
        self.navigationController.presentedViewController?.dismiss(animated: true)
    }
}

// MARK: - Private
extension VacationCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.vacation()
            let viewModel = VacationViewModel(
                userInterface: controller,
                apiClient: apiClient,
                errorHandler: self.dependencyContainer.errorHandler,
                coordinator: self)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
    
    private func runNewVacationFlow(availableVacationDays: Int) {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        let coordinator = NewVacationCoordinator(
            dependencyContainer: self.dependencyContainer,
            parentViewController: parentViewController)
        self.add(child: coordinator)
        coordinator.start(availableVacationDays: availableVacationDays) { [weak self, weak coordinator] in
            self?.remove(child: coordinator)
        }
    }
}
