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
    func viewDidFinish(isTaskChanged: Bool)
}

class WorkTimeCoordinator: BaseNavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    private weak var sourceView: UIView?
    private let flowType: WorkTimeViewModel.FlowType
    
    private var customFinishHandler: ((_ isTaskChanged: Bool) -> Void)?
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType,
         parentViewController: UIViewController?,
         sourceView: UIView?,
         flowType: WorkTimeViewModel.FlowType) {
        self.parentViewController = parentViewController
        self.dependencyContainer = dependencyContainer
        self.flowType = flowType
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
    }
    
    // MARK: - Overridden
    override func start(finishCompletion: (() -> Void)?) {
        super.start(finishCompletion: finishCompletion)
        runMainFlow()
    }
    
    override func finish() {
        customFinishHandler?(false)
        super.finish()
    }
    
    // MARK: - Internal
    func start(finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        super.start(finishCompletion: nil)
        customFinishHandler = finishHandler
        runMainFlow()
    }
    
    func finish(isTaskChanged: Bool) {
        customFinishHandler?(isTaskChanged)
        super.finish()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        guard let apiClient = dependencyContainer.apiClient else { return assertionFailure("Api client is nil") }
        let controller: WorkTimeViewControllerable? = dependencyContainer.storyboardsManager.controller(storyboard: .workTime)
        guard let workTimeViewController = controller else { return }
        let viewModel = WorkTimeViewModel(userInterface: workTimeViewController,
                                          coordinator: self,
                                          apiClient: apiClient,
                                          errorHandler: dependencyContainer.errorHandler,
                                          calendar: Calendar.autoupdatingCurrent,
                                          flowType: flowType)
        workTimeViewController.configure(viewModel: viewModel, notificationCenter: dependencyContainer.notificationCenter)
        navigationController.setViewControllers([workTimeViewController], animated: false)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.tintColor = .crimson
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        if let sourceView = self.sourceView {
            showWorkTimeController(controller: navigationController, sourceView: sourceView)
        } else {
            parentViewController?.present(navigationController, animated: true)
        }
    }
    
    private func showWorkTimeController(controller: UIViewController, sourceView: UIView) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 320)
        controller.popoverPresentationController?.permittedArrowDirections = .right
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.midY, width: 0, height: 0)
        parentViewController?.children.last?.present(controller, animated: true)
    }
}

// MARK: - WorkTimeCoordinatorType
extension WorkTimeCoordinator: WorkTimeCoordinatorType {
    func viewDidFinish(isTaskChanged: Bool) {
        finish(isTaskChanged: isTaskChanged)
    }
}
