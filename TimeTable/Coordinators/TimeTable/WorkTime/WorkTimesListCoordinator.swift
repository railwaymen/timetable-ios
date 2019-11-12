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
    func workTimesRequestedForWorkTimeView(sourceView: UIView,
                                           flowType: WorkTimeViewModel.FlowType,
                                           finishHandler: @escaping (_ isTaskChanged: Bool) -> Void)
    func workTimesRequestedForSafari(url: URL)
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
        self.root.tabBarItem = self.tabBarItem
    }
    
    // MARK: - CoordinatorType
    override func start(finishCompletion: (() -> Void)?) {
        super.start(finishCompletion: finishCompletion)
        self.runMainFlow()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient,
            let accessService = self.dependencyContainer.accessService else { return assertionFailure("Api client or access service is nil") }
        let controller: WorkTimesListViewControllerable? = self.dependencyContainer.storyboardsManager.controller(storyboard: .workTimesList)
        guard let workTimesListViewController = controller else { return }
        let contentProvider = WorkTimesListContentProvider(apiClient: apiClient,
                                                           accessService: accessService,
                                                           dispatchGroupFactory: self.dependencyContainer.dispatchGroupFactory)
        let viewModel = WorkTimesListViewModel(userInterface: workTimesListViewController,
                                               coordinator: self,
                                               contentProvider: contentProvider,
                                               errorHandler: self.dependencyContainer.errorHandler)
        controller?.configure(viewModel: viewModel)
        self.navigationController.setViewControllers([workTimesListViewController], animated: false)
    }
    
    private func runWorkTimeFlow(sourceView: UIView,
                                 flowType: WorkTimeViewModel.FlowType,
                                 finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        let coordinator = WorkTimeCoordinator(dependencyContainer: self.dependencyContainer,
                                              parentViewController: self.navigationController.topViewController,
                                              sourceView: sourceView,
                                              flowType: flowType)
        self.addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] isTaskChanged in
            self?.removeChildCoordinator(child: coordinator)
            finishHandler(isTaskChanged)
        }
    }
}

// MARK: - WorkTimesListCoordinatorDelegate
extension WorkTimesListCoordinator: WorkTimesListCoordinatorDelegate {
    func workTimesRequestedForWorkTimeView(sourceView: UIView,
                                           flowType: WorkTimeViewModel.FlowType,
                                           finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        self.runWorkTimeFlow(sourceView: sourceView, flowType: flowType, finishHandler: finishHandler)
    }

    func workTimesRequestedForSafari(url: URL) {
        self.dependencyContainer.application?.open(url)
    }
}
