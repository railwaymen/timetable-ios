//
//  RemoteWorkCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

class RemoteWorkCoordinator: NavigationCoordinator, TabBarChildCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    let tabBarItem: UITabBarItem
    
    var root: UIViewController {
        return self.navigationController
    }
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        self.tabBarItem = UITabBarItem(
            title: R.string.localizable.remotework_title(),
            image: #imageLiteral(resourceName: "tab_bar_projects_icon"), // TO_DO - change tab bar icon TIM-332
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

// MARK: - Private
extension RemoteWorkCoordinator {
    private func runMainFlow() {
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.remoteWork()
            let viewModel = RemoteWorkViewModel(userInterface: controller)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
