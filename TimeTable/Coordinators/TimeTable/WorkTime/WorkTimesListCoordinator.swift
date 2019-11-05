//
//  WorkTimesListCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesListApiClient = (ApiClientProjectsType & ApiClientWorkTimesType & ApiClientUsersType & ApiClientMatchingFullTimeType)

protocol WorkTimesListCoordinatorDelegate: class {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIView, lastTask: Task?, finishHandler: @escaping (_ isTaskChanged: Bool) -> Void)
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task, finishHandler: @escaping (_ isTaskChanged: Bool) -> Void)
    func workTimesRequestedForDuplicateWorkTimeView(sourceView: UIView,
                                                    duplicatedTask: Task,
                                                    lastTask: Task?,
                                                    finishHandler: @escaping (_ isTaskChanged: Bool) -> Void)
}

class WorkTimesListCoordinator: BaseNavigationCoordinator, BaseTabBarCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    var root: UIViewController {
        return self.navigationController
    }
    var tabBarItem: UITabBarItem
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        
        self.tabBarItem = UITabBarItem(title: "tabbar.title.timesheet".localized,
                                       image: .timesheet,
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
        guard let apiClient = dependencyContainer.apiClient,
            let accessService = dependencyContainer.accessService else { return assertionFailure("Api client or access service is nil") }
        let controller: WorkTimesListViewControllerable? = dependencyContainer.storyboardsManager.controller(storyboard: .workTimesList)
        guard let workTimesListViewController = controller else { return }
        let contentProvider = WorkTimesListContentProvider(apiClient: apiClient,
                                                           accessService: accessService,
                                                           dispatchGroupFactory: dependencyContainer.dispatchGroupFactory)
        let viewModel = WorkTimesListViewModel(userInterface: workTimesListViewController,
                                               coordinator: self,
                                               contentProvider: contentProvider,
                                               errorHandler: dependencyContainer.errorHandler)
        controller?.configure(viewModel: viewModel)
        navigationController.setViewControllers([workTimesListViewController], animated: false)
    }
    
    private func runWorkTimeFlow(sourceView: UIView,
                                 lastTask: Task?,
                                 editedTask: Task?,
                                 duplicatedTask: Task?,
                                 finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        let coordinator = WorkTimeCoordinator(dependencyContainer: dependencyContainer,
                                              parentViewController: navigationController.topViewController,
                                              sourceView: sourceView,
                                              lastTask: lastTask,
                                              editedTask: editedTask,
                                              duplicatedTask: duplicatedTask)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] isTaskChanged in
            self?.removeChildCoordinator(child: coordinator)
            finishHandler(isTaskChanged)
        }
    }
}

// MARK: - WorkTimesListCoordinatorDelegate
extension WorkTimesListCoordinator: WorkTimesListCoordinatorDelegate {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIView, lastTask: Task?, finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        self.runWorkTimeFlow(sourceView: sourceView, lastTask: lastTask, editedTask: nil, duplicatedTask: nil, finishHandler: finishHandler)
    }
    
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task, finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        self.runWorkTimeFlow(sourceView: sourceView, lastTask: nil, editedTask: editedTask, duplicatedTask: nil, finishHandler: finishHandler)
    }
    
    func workTimesRequestedForDuplicateWorkTimeView(sourceView: UIView,
                                                    duplicatedTask: Task,
                                                    lastTask: Task?,
                                                    finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        self.runWorkTimeFlow(sourceView: sourceView, lastTask: lastTask, editedTask: nil, duplicatedTask: duplicatedTask, finishHandler: finishHandler)
    }
}
