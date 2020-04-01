//
//  ProjectsCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class ProjectsCoordinator: NavigationCoordinator, TabBarChildCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    var root: UIViewController {
        return self.navigationController
    }
    
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        self.tabBarItem = UITabBarItem(
            title: "tabbar.title.projects".localized,
            image: .projects,
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
extension ProjectsCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client or access service is nil")
            return
        }
        let controller: ProjectsViewControllerable? = self.dependencyContainer.storyboardsManager.controller(
            storyboard: .projects)
        let viewModel = ProjectsViewModel(
            userInterface: controller,
            apiClient: apiClient,
            errorHandler: self.dependencyContainer.errorHandler,
            notificationCenter: self.dependencyContainer.notificationCenter)
        controller?.configure(viewModel: viewModel)
        if let controller = controller {        
            self.navigationController.pushViewController(controller, animated: false)
        }
    }
}
