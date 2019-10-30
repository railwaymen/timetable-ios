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
        var image: UIImage = #imageLiteral(resourceName: "project_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "rectangle.grid.2x2.fill") {
            image = sfSymbol
        }
        self.tabBarItem = UITabBarItem(title: "tabbar.title.projects".localized,
                                       image: image,
                                       selectedImage: nil)
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.navigationBar.tintColor = .crimson
        self.root.tabBarItem = tabBarItem
    }
    
    // MARK: - CoordinatorType
    func start() {
        self.runMainFlow()
        super.start()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        guard let apiClient = dependencyContainer.apiClient else { return assertionFailure("Api client or access service is nil") }
        let controller: ProjectsViewControllerable? = dependencyContainer.storyboardsManager.controller(storyboard: .projects)
        let viewModel = ProjectsViewModel(userInterface: controller,
                                          apiClient: apiClient,
                                          errorHandler: dependencyContainer.errorHandler)
        controller?.configure(viewModel: viewModel)
        if let controller = controller {        
            navigationController.pushViewController(controller, animated: false)
        }
    }
}
