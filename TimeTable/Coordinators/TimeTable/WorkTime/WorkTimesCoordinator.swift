//
//  WorkTimesCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesApiClient = (ApiClientProjectsType & ApiClientWorkTimesType & ApiClientUsersType & ApiClientMatchingFullTimeType)

protocol WorkTimesCoordinatorDelegate: class {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIView, lastTask: Task?)
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task)
    func workTimesRequestedForDuplicateWorkTimeView(sourceView: UIView, duplicatedTask: Task, lastTask: Task?)
}

class WorkTimesCoordinator: BaseNavigationCoordinator, BaseTabBarCoordinatorType {
    private weak var messagePresenter: MessagePresenterType?
    private let storyboardsManager: StoryboardsManagerType
    private let apiClient: WorkTimesApiClient
    private let accessService: AccessServiceUserIDType
    private let errorHandler: ErrorHandlerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         storyboardsManager: StoryboardsManagerType,
         apiClient: WorkTimesApiClient,
         accessService: AccessServiceUserIDType,
         errorHandler: ErrorHandlerType) {
        self.storyboardsManager = storyboardsManager
        self.apiClient = apiClient
        self.accessService = accessService
        self.errorHandler = errorHandler
        self.tabBarItem = UITabBarItem(title: "tabbar.title.work_time".localized,
                                       image: #imageLiteral(resourceName: "work_times_icon"),
                                       selectedImage: nil)
        super.init(window: window, messagePresenter: messagePresenter)
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
        let controller: WorkTimesViewControlleralbe? = storyboardsManager.controller(storyboard: .workTimes, controllerIdentifier: .initial)
        guard let workTimesViewController = controller else { return }
        let contentProvider = WorkTimesContentProvider(apiClient: apiClient, accessService: accessService)
        let viewModel = WorkTimesViewModel(userInterface: workTimesViewController,
                                           coordinator: self,
                                           contentProvider: contentProvider,
                                           errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel)
        navigationController.pushViewController(workTimesViewController, animated: false)
    }
    
    private func runWorkTimeFlow(sourceView: UIView, lastTask: Task?, editedTask: Task?, duplicatedTask: Task?) {
        let coordinator = WorkTimeCoordinator(window: self.window,
                                              messagePresenter: self.messagePresenter,
                                              parentViewController: self.navigationController.topViewController,
                                              sourceView: sourceView,
                                              apiClient: self.apiClient,
                                              errorHandler: self.errorHandler,
                                              storyboardsManager: self.storyboardsManager,
                                              lastTask: lastTask,
                                              editedTask: editedTask,
                                              duplicatedTask: duplicatedTask)
        self.addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] in
            self?.removeChildCoordinator(child: coordinator)
        }
    }
}

// MARK: - WorkTimesCoordinatorDelegate
extension WorkTimesCoordinator: WorkTimesCoordinatorDelegate {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIView, lastTask: Task?) {
        self.runWorkTimeFlow(sourceView: sourceView, lastTask: lastTask, editedTask: nil, duplicatedTask: nil)
    }
    
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task) {
        self.runWorkTimeFlow(sourceView: sourceView, lastTask: nil, editedTask: editedTask, duplicatedTask: nil)
    }
    
    func workTimesRequestedForDuplicateWorkTimeView(sourceView: UIView, duplicatedTask: Task, lastTask: Task?) {
        self.runWorkTimeFlow(sourceView: sourceView, lastTask: lastTask, editedTask: nil, duplicatedTask: duplicatedTask)
    }
}
