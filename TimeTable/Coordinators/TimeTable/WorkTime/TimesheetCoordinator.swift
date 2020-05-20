//
//  TimesheetCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol TimesheetCoordinatorDelegate: class {
    func timesheetRequestedForWorkTimeView(
        sourceView: UIView,
        flowType: WorkTimeViewModel.FlowType,
        finishHandler: @escaping (_ isTaskChanged: Bool) -> Void)
    func timesheetRequestedForSafari(url: URL)
    func timesheetRequestedForTaskHistory(taskForm: TaskForm)
    func timesheetRequestedForProfileView()
    func timesheetRequestedForProjectPicker(
        projects: [SimpleProjectRecordDecoder],
        completion: @escaping (SimpleProjectRecordDecoder?) -> Void)
}

class TimesheetCoordinator: NavigationCoordinator, TabBarChildCoordinatorType {
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
            image: #imageLiteral(resourceName: "tab_bar_timesheet_icon"),
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

// MARK: - TimesheetCoordinatorDelegate
extension TimesheetCoordinator: TimesheetCoordinatorDelegate {
    func timesheetRequestedForWorkTimeView(
        sourceView: UIView,
        flowType: WorkTimeViewModel.FlowType,
        finishHandler: @escaping (_ isTaskChanged: Bool) -> Void
    ) {
        self.runWorkTimeFlow(sourceView: sourceView, flowType: flowType, finishHandler: finishHandler)
    }
    
    func timesheetRequestedForSafari(url: URL) {
        self.dependencyContainer.application?.open(url)
    }
    
    func timesheetRequestedForTaskHistory(taskForm: TaskForm) {
        self.runTaskHistoryFlow(taskForm: taskForm)
    }
    
    func timesheetRequestedForProfileView() {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        self.dependencyContainer.parentCoordinator?.showProfile(parentViewController: parentViewController)
    }
    
    func timesheetRequestedForProjectPicker(
        projects: [SimpleProjectRecordDecoder],
        completion: @escaping (SimpleProjectRecordDecoder?) -> Void
    ) {
        self.runProjectPickerFlow(projects: projects, completion: completion)
    }
}

// MARK: - Private
extension TimesheetCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.timesheet()
            let contentProvider = TimesheetContentProvider(
                apiClient: apiClient,
                accessService: self.dependencyContainer.accessService,
                dispatchGroupFactory: self.dependencyContainer.dispatchGroupFactory)
            let viewModel = TimesheetViewModel(
                userInterface: controller,
                coordinator: self,
                contentProvider: contentProvider,
                errorHandler: self.dependencyContainer.errorHandler,
                messagePresenter: self.dependencyContainer.messagePresenter,
                keyboardManager: self.dependencyContainer.keyboardManager)
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
    
    private func runProjectPickerFlow(
        projects: [SimpleProjectRecordDecoder],
        completion: @escaping (SimpleProjectRecordDecoder?) -> Void
    ) {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        let coordinator = ProjectPickerCoordinator(
            dependencyContainer: self.dependencyContainer,
            parentViewController: parentViewController,
            projects: projects)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] project in
            self?.remove(child: coordinator)
            completion(project)
        }
    }
}
