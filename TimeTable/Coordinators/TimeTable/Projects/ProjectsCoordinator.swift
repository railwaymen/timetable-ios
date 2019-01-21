//
//  ProjectsCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class ProjectsCoordinator: BaseNavigationCoordinator, BaseTabBarCordninatorType {
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: ApiClientProjectsType
    private let errorHandler: ErrorHandlerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType, apiClient: ApiClientProjectsType, errorHandler: ErrorHandlerType) {
        self.storyboardsManager = storyboardsManager
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.tabBarItem = UITabBarItem(title: "tabbar.title.projects".localized, image: nil, selectedImage: nil)
        super.init(window: window)
        self.root.tabBarItem = tabBarItem
    }
    
    // MARK: - CoordinatorType
    func start() {
        self.runMainFlow()
        super.start()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        let controller: ProjectsViewControllerable? = storyboardsManager.controller(storyboard: .projects, controllerIdentifier: .initial)
        let viewModel = ProjectsViewModel(userInterface: controller, apiClient: apiClient, errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel)
        if let controller = controller {        
            navigationController.pushViewController(controller, animated: false)
        }
    }
}
