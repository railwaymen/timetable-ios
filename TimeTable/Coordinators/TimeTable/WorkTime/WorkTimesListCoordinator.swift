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
    func workTimesRequestedForNewWorkTimeView(sourceView: UIView, lastTask: Task?)
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task)
    func workTimesRequestedForDuplicateWorkTimeView(sourceView: UIView, duplicatedTask: Task, lastTask: Task?)
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
        var image: UIImage = #imageLiteral(resourceName: "work_times_icon")
        if #available(iOS 13, *), let sfSymbol = UIImage(systemName: "clock.fill") {
            image = sfSymbol
        }
        self.tabBarItem = UITabBarItem(title: "tabbar.title.timesheet".localized,
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
    
    private func runWorkTimeFlow(sourceView: UIView, lastTask: Task?, editedTask: Task?, duplicatedTask: Task?) {
        let coordinator = WorkTimeCoordinator(dependencyContainer: dependencyContainer,
                                              parentViewController: navigationController.topViewController,
                                              sourceView: sourceView,
                                              lastTask: lastTask,
                                              editedTask: editedTask,
                                              duplicatedTask: duplicatedTask)
        addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] in
            self?.removeChildCoordinator(child: coordinator)
        }
    }
}

// MARK: - WorkTimesListCoordinatorDelegate
extension WorkTimesListCoordinator: WorkTimesListCoordinatorDelegate {
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
