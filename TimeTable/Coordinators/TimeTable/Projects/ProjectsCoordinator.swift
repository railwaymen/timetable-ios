//
//  ProjectsCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class ProjectsCoordinator: BaseNavigationCoordinator, BaseTabBarCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    var root: UIViewController {
        return self.navigationController
    }
    
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        self.tabBarItem = UITabBarItem(title: "tabbar.title.projects".localized,
                                       image: .projects,
                                       selectedImage: nil)
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.navigationBar.tintColor = .crimson
        self.root.tabBarItem = self.tabBarItem
    }
    
    // MARK: - Overridden
    override func start(finishCompletion: (() -> Void)?) {
        super.start(finishCompletion: finishCompletion)
        self.runMainFlow()
    }
}
  
// MARK: - Private
extension ProjectsCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else { return assertionFailure("Api client or access service is nil") }
        let controller: ProjectsViewControllerable? = self.dependencyContainer.storyboardsManager.controller(storyboard: .projects)
        let viewModel = ProjectsViewModel(userInterface: controller,
                                          apiClient: apiClient,
                                          errorHandler: self.dependencyContainer.errorHandler)
        controller?.configure(viewModel: viewModel)
        if let controller = controller {        
            self.navigationController.pushViewController(controller, animated: false)
        }
    }
}
