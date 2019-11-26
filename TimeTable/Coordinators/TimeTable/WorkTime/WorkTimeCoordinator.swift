//
//  WorkTimeCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 11/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimeApiClientType = ApiClientWorkTimesType & ApiClientProjectsType

protocol WorkTimeCoordinatorType: class {
    func showProjectPicker(projects: [ProjectDecoder], finishHandler: @escaping ProjectPickerCoordinator.FinishHandlerType)
    func viewDidFinish(isTaskChanged: Bool)
}

class WorkTimeCoordinator: BaseNavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    private weak var sourceView: UIView?
    private let flowType: WorkTimeViewModel.FlowType
    
    private var customFinishHandler: ((_ isTaskChanged: Bool) -> Void)?
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parentViewController: UIViewController?,
        sourceView: UIView?,
        flowType: WorkTimeViewModel.FlowType
    ) {
        self.parentViewController = parentViewController
        self.dependencyContainer = dependencyContainer
        self.flowType = flowType
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
    }
    
    // MARK: - Overridden
    override func start(finishCompletion: (() -> Void)?) {
        super.start(finishCompletion: finishCompletion)
        self.runMainFlow()
    }
    
    override func finish() {
        self.customFinishHandler?(false)
        super.finish()
    }
    
    // MARK: - Internal
    func start(finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        super.start(finishCompletion: nil)
        self.customFinishHandler = finishHandler
        self.runMainFlow()
    }
    
    func finish(isTaskChanged: Bool) {
        self.customFinishHandler?(isTaskChanged)
        super.finish()
    }
}

// MARK: - WorkTimeCoordinatorType
extension WorkTimeCoordinator: WorkTimeCoordinatorType {
    func showProjectPicker(projects: [ProjectDecoder], finishHandler: @escaping ProjectPickerCoordinator.FinishHandlerType) {
        self.runProjectPickerFlow(projects: projects, finishHandler: finishHandler)
    }
    
    func viewDidFinish(isTaskChanged: Bool) {
        self.finish(isTaskChanged: isTaskChanged)
    }
}

// MARK: - Private
extension WorkTimeCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else { return assertionFailure("Api client is nil") }
        let controller: WorkTimeViewControllerable? = self.dependencyContainer.storyboardsManager.controller(storyboard: .workTime)
        guard let workTimeViewController = controller else { return }
        let viewModel = WorkTimeViewModel(
            userInterface: workTimeViewController,
            coordinator: self,
            apiClient: apiClient,
            errorHandler: self.dependencyContainer.errorHandler,
            calendar: Calendar.autoupdatingCurrent,
            flowType: self.flowType)
        workTimeViewController.configure(viewModel: viewModel, notificationCenter: self.dependencyContainer.notificationCenter)
        self.navigationController.setViewControllers([workTimeViewController], animated: false)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.tintColor = .crimson
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        if let sourceView = self.sourceView {
            self.showWorkTimeController(controller: self.navigationController, sourceView: sourceView)
        } else {
            self.parentViewController?.present(self.navigationController, animated: true)
        }
    }
    
    private func runProjectPickerFlow(projects: [ProjectDecoder], finishHandler: @escaping ProjectPickerCoordinator.FinishHandlerType) {
        let coordinator = ProjectPickerCoordinator(
            dependencyContainer: self.dependencyContainer,
            parentViewController: self.navigationController,
            projects: projects)
        self.addChildCoordinator(child: coordinator)
        coordinator.start { [weak self, weak coordinator] project in
            self?.removeChildCoordinator(child: coordinator)
            finishHandler(project)
        }
    }
    
    private func showWorkTimeController(controller: UIViewController, sourceView: UIView) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 320)
        controller.popoverPresentationController?.permittedArrowDirections = .right
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.midY, width: 0, height: 0)
        self.parentViewController?.children.last?.present(controller, animated: true)
    }
}
