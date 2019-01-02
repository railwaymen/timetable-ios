//
//  WorkTimeCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class WorkTimeCoordinator: BaseNavigationCoordinator, BaseTabBarCordninatorType {
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: ApiClientWorkTimesType
    private let errorHandler: ErrorHandlerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType, apiClient: ApiClientWorkTimesType, errorHandler: ErrorHandlerType) {
        self.storyboardsManager = storyboardsManager
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.tabBarItem = UITabBarItem(title: "Work Time", image: nil, selectedImage: nil)
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
        let controller: WorkTimesViewControlleralbe? = storyboardsManager.controller(storyboard: .workTimes, controllerIdentifier: .initial)
        guard let workTimesViewController = controller else { return }
        let viewModel = WorkTimesViewModel(userInterface: workTimesViewController, apiClient: apiClient, errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel)
        navigationController.pushViewController(workTimesViewController, animated: false)
    }
}
