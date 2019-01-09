//
//  WorkTimesCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol WorkTimesCoordinatorDelegate: class {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIBarButtonItem)
}

class WorkTimesCoordinator: BaseNavigationCoordinator, BaseTabBarCordninatorType {
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
        let viewModel = WorkTimesViewModel(userInterface: workTimesViewController, coordinator: self, apiClient: apiClient, errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel)
        navigationController.pushViewController(workTimesViewController, animated: false)
    }
}

// MARK: - WorkTimesCoordinatorDelegate
extension WorkTimesCoordinator: WorkTimesCoordinatorDelegate {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIBarButtonItem) {
        let controller: WorkTimeViewControlleralbe? = storyboardsManager.controller(storyboard: .workTime, controllerIdentifier: .initial)
        let viewModel = WorkTimeViewModel(userInterface: controller)
        controller?.configure(viewModel: viewModel)
        controller?.modalPresentationStyle = .popover
        controller?.preferredContentSize = CGSize(width: 300, height: 320)
        controller?.popoverPresentationController?.permittedArrowDirections = .up
        controller?.popoverPresentationController?.barButtonItem = sourceView
        guard let workTimeViewController = controller else { return }
        root.children.last?.present(workTimeViewController, animated: true)
    }
}
