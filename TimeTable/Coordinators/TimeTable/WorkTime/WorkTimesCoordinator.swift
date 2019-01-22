//
//  WorkTimesCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesApiClient = (ApiClientProjectsType & ApiClientWorkTimesType & ApiClientUsersType)

protocol WorkTimesCoordinatorDelegate: class {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIButton)
}

class WorkTimesCoordinator: BaseNavigationCoordinator, BaseTabBarCordninatorType {
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: WorkTimesApiClient
    private let errorHandler: ErrorHandlerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType, apiClient: WorkTimesApiClient, errorHandler: ErrorHandlerType) {
        self.storyboardsManager = storyboardsManager
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.tabBarItem = UITabBarItem(title: "tabbar.title.work_time".localized, image: nil, selectedImage: nil)
        super.init(window: window)
        self.navigationController.setNavigationBarHidden(true, animated: false)
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
    func workTimesRequestedForNewWorkTimeView(sourceView: UIButton) {
        let controller: WorkTimeViewControlleralbe? = storyboardsManager.controller(storyboard: .workTime, controllerIdentifier: .initial)
        let viewModel = WorkTimeViewModel(userInterface: controller, apiClient: apiClient, errorHandler: errorHandler, calendar: Calendar.autoupdatingCurrent)
        controller?.configure(viewModel: viewModel)
        controller?.modalPresentationStyle = .popover
        controller?.preferredContentSize = CGSize(width: 300, height: 320)
        controller?.popoverPresentationController?.permittedArrowDirections = .right
        controller?.popoverPresentationController?.sourceView = sourceView
        controller?.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.midY, width: 0, height: 0)
        guard let workTimeViewController = controller else { return }
        root.children.last?.present(workTimeViewController, animated: true)
    }
}
