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
            title: R.string.localizable.tabbar_title_vacation(),
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
}

// MARK: - Private
extension VacationCoordinator {
    private func runMainFlow() {
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.vacation()
            let viewModel = VacationViewModel(userInterface: controller, coordinator: self)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
