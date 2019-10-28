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
    func viewDidFinish()
}

class WorkTimeCoordinator: BaseNavigationCoordinator {
    private weak var parentViewController: UIViewController?
    private weak var sourceView: UIView?
    private let apiClient: WorkTimeApiClientType
    private let errorHandler: ErrorHandlerType
    private let storyboardsManager: StoryboardsManagerType
    private let lastTask: Task?
    private let editedTask: Task?
    private let duplicatedTask: Task?
    
    // MARK: - Initialization
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         parentViewController: UIViewController?,
         sourceView: UIView?,
         apiClient: WorkTimeApiClientType,
         errorHandler: ErrorHandlerType,
         storyboardsManager: StoryboardsManagerType,
         lastTask: Task?,
         editedTask: Task?,
         duplicatedTask: Task?) {
        self.parentViewController = parentViewController
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.storyboardsManager = storyboardsManager
        self.lastTask = lastTask
        self.editedTask = editedTask
        self.duplicatedTask = duplicatedTask
        super.init(window: window, messagePresenter: messagePresenter)
    }
    
    // MARK: - Overridden
    override func start(finishCompletion: (() -> Void)?) {
        super.start(finishCompletion: finishCompletion)
        self.runMainFlow()
    }
    
    // MARK: - Private
    private func runMainFlow() {
        let controller: WorkTimeViewControllerable? = self.storyboardsManager.controller(storyboard: .workTime, controllerIdentifier: .initial)
        guard let workTimeViewController = controller else { return }
        let viewModel = WorkTimeViewModel(userInterface: workTimeViewController,
                                          coordinator: self,
                                          apiClient: self.apiClient,
                                          errorHandler: self.errorHandler,
                                          calendar: Calendar.autoupdatingCurrent,
                                          lastTask: self.lastTask,
                                          editedTask: self.editedTask,
                                          duplicatedTask: self.duplicatedTask)
        workTimeViewController.configure(viewModel: viewModel, notificationCenter: NotificationCenter.default)
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
    
    private func showWorkTimeController(controller: UIViewController, sourceView: UIView) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 320)
        controller.popoverPresentationController?.permittedArrowDirections = .right
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.midY, width: 0, height: 0)
        self.parentViewController?.children.last?.present(controller, animated: true)
    }
}

// MARK: - WorkTimeCoordinatorType
extension WorkTimeCoordinator: WorkTimeCoordinatorType {
    func viewDidFinish() {
        self.finish()
    }
}
