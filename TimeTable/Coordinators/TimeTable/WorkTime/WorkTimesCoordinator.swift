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
    func workTimesRequestedForNewWorkTimeView(sourceView: UIButton, lastTask: Task?)
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task)
}

class WorkTimesCoordinator: BaseNavigationCoordinator, BaseTabBarCordninatorType {
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
        self.tabBarItem = UITabBarItem(title: "tabbar.title.work_time".localized, image: nil, selectedImage: nil)
        super.init(window: window, messagePresenter: messagePresenter)
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
        let contentProvider = WorkTimesContentProvider(apiClient: apiClient, accessService: accessService)
        let viewModel = WorkTimesViewModel(userInterface: workTimesViewController,
                                           coordinator: self,
                                           contentProvider: contentProvider,
                                           errorHandler: errorHandler)
        controller?.configure(viewModel: viewModel)
        navigationController.pushViewController(workTimesViewController, animated: false)
    }
    
    private func showWorkTimeController(controller: UIViewController, sourceView: UIView) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 320)
        controller.popoverPresentationController?.permittedArrowDirections = .right
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.midY, width: 0, height: 0)
        root.children.last?.present(controller, animated: true)
    }
}

// MARK: - WorkTimesCoordinatorDelegate
extension WorkTimesCoordinator: WorkTimesCoordinatorDelegate {
    func workTimesRequestedForNewWorkTimeView(sourceView: UIButton, lastTask: Task?) {
        guard let controller: WorkTimeViewControlleralbe = storyboardsManager.controller(storyboard: .workTime, controllerIdentifier: .initial) else { return }
        let viewModel = WorkTimeViewModel(userInterface: controller,
                                          apiClient: apiClient,
                                          errorHandler: errorHandler,
                                          calendar: Calendar.autoupdatingCurrent,
                                          lastTask: lastTask,
                                          editedTask: nil)
        controller.configure(viewModel: viewModel, notificationCenter: NotificationCenter.default)
        showWorkTimeController(controller: controller, sourceView: sourceView)
    }
    
    func workTimesRequestedForEditWorkTimeView(sourceView: UIView, editedTask: Task) {
        guard let controller: WorkTimeViewControlleralbe = storyboardsManager.controller(storyboard: .workTime, controllerIdentifier: .initial) else { return }
        let viewModel = WorkTimeViewModel(userInterface: controller,
                                          apiClient: apiClient,
                                          errorHandler: errorHandler,
                                          calendar: Calendar.autoupdatingCurrent,
                                          lastTask: nil,
                                          editedTask: editedTask)
        controller.configure(viewModel: viewModel, notificationCenter: NotificationCenter.default)
        showWorkTimeController(controller: controller, sourceView: sourceView)
    }
}
