//
//  WorkTimesListCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesListApiClient = (
    ApiClientProjectsType
    & ApiClientWorkTimesType
    & ApiClientUsersType
    & ApiClientAccountingPeriodsType)

protocol WorkTimesListCoordinatorDelegate: class {
    func workTimesRequestedForWorkTimeView(
        sourceView: UIView,
        flowType: WorkTimeViewModel.FlowType,
        finishHandler: @escaping (_ isTaskChanged: Bool) -> Void)
    func workTimesRequestedForSafari(url: URL)
    func workTimesRequestedForTaskHistory(taskForm: TaskForm)
    func workTimesRequestedForProfileView()
}

class WorkTimesListCoordinator: NavigationCoordinator, TabBarChildCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    let tabBarItem: UITabBarItem
    
    var root: UIViewController {
        return self.navigationController
    }
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        
        self.tabBarItem = UITabBarItem(
            title: R.string.localizable.timesheet_title(),
            image: .timesheet,
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

// MARK: - WorkTimesListCoordinatorDelegate
extension WorkTimesListCoordinator: WorkTimesListCoordinatorDelegate {
    func workTimesRequestedForWorkTimeView(
        sourceView: UIView,
        flowType: WorkTimeViewModel.FlowType,
        finishHandler: @escaping (_ isTaskChanged: Bool) -> Void
    ) {
        self.runWorkTimeFlow(sourceView: sourceView, flowType: flowType, finishHandler: finishHandler)
    }
    
    func workTimesRequestedForSafari(url: URL) {
        self.dependencyContainer.application?.open(url)
    }
    
    func workTimesRequestedForTaskHistory(taskForm: TaskForm) {
        self.runTaskHistoryFlow(taskForm: taskForm)
    }
    
    func workTimesRequestedForProfileView() {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        self.dependencyContainer.parentCoordinator?.showProfile(parentViewController: parentViewController)
    }
}

// MARK: - Private
extension WorkTimesListCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.workTimesList()
            let contentProvider = WorkTimesListContentProvider(
                apiClient: apiClient,
                accessService: self.dependencyContainer.accessService,
                dispatchGroupFactory: self.dependencyContainer.dispatchGroupFactory)
            let viewModel = WorkTimesListViewModel(
                userInterface: controller,
                coordinator: self,
                contentProvider: contentProvider,
                errorHandler: self.dependencyContainer.errorHandler,
                messagePresenter: self.dependencyContainer.messagePresenter)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
    
    private func runWorkTimeFlow(
        sourceView: UIView,
        flowType: WorkTimeViewModel.FlowType,
        finishHandler: @escaping (_ isTaskChanged: Bool) -> Void
    ) {
        let coordinator = WorkTimeCoordinator(
            dependencyContainer: self.dependencyContainer,
            parentViewController: self.navigationController.topViewController,
            sourceView: sourceView,
            flowType: flowType)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] isTaskChanged in
            self?.remove(child: coordinator)
            finishHandler(isTaskChanged)
        }
    }
    
    private func runTaskHistoryFlow(taskForm: TaskForm) {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        let coordinator = TaskHistoryCoordinator(
            dependencyContainer: self.dependencyContainer,
            parentViewController: parentViewController,
            taskForm: taskForm)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] in
            self?.remove(child: coordinator)
        }
    }
}
