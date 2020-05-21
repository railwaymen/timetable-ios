//
//  WorkTimeCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 11/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol WorkTimeCoordinatorType: class {
    func configure(contentViewController: WorkTimeViewControllerable) -> WorkTimeContainerContentType?
    func configure(errorView: ErrorViewable, action: @escaping () -> Void) -> ErrorViewModelParentType
    func showProjectPicker(
        projects: [SimpleProjectRecordDecoder],
        finishHandler: @escaping ProjectPickerCoordinator.CustomFinishHandlerType)
    func dismissView(isTaskChanged: Bool)
}

class WorkTimeCoordinator: NavigationCoordinator {
    private let dependencyContainer: DependencyContainerType
    private weak var parentViewController: UIViewController?
    private weak var sourceView: UIView?
    private let flowType: WorkTimeViewModel.FlowType
    
    private var customFinishHandler: ((_ isTaskChanged: Bool) -> Void)?
    
    private var contentProvider: WorkTimeContentProviderable? {
        guard let apiClient = self.dependencyContainer.requireApiClient() else { return nil }
        return WorkTimeContentProvider(
            apiClient: apiClient,
            calendar: Calendar.autoupdatingCurrent,
            dateFactory: self.dependencyContainer.dateFactory,
            dispatchGroupFactory: self.dependencyContainer.dispatchGroupFactory,
            errorHandler: self.dependencyContainer.errorHandler)
    }
    
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
        super.init(window: dependencyContainer.window)
    }
    
    // MARK: - Overridden
    override func start(finishHandler: (() -> Void)?) {
        super.start(finishHandler: finishHandler)
        self.runMainFlow()
        self.setUpNativationController()
    }
    
    override func finish() {
        self.customFinishHandler?(false)
        super.finish()
    }
    
    // MARK: - Internal
    func start(finishHandler: @escaping (_ isTaskChanged: Bool) -> Void) {
        super.start(finishHandler: nil)
        self.customFinishHandler = finishHandler
        self.runMainFlow()
        self.setUpNativationController()
    }
    
    func finish(isTaskChanged: Bool) {
        self.customFinishHandler?(isTaskChanged)
        super.finish()
    }
}

// MARK: - WorkTimeCoordinatorType
extension WorkTimeCoordinator: WorkTimeCoordinatorType {
    func configure(contentViewController: WorkTimeViewControllerable) -> WorkTimeContainerContentType? {
        guard let contentProvider = self.contentProvider else { return nil }
        let viewModel = WorkTimeViewModel(
            userInterface: contentViewController,
            coordinator: self,
            contentProvider: contentProvider,
            errorHandler: self.dependencyContainer.errorHandler,
            calendar: Calendar.autoupdatingCurrent,
            keyboardManager: self.dependencyContainer.keyboardManager,
            flowType: self.flowType,
            taskFormFactory: self.dependencyContainer.taskFormFactory)
        contentViewController.configure(viewModel: viewModel)
        return viewModel
    }
    
    func configure(errorView: ErrorViewable, action: @escaping () -> Void) -> ErrorViewModelParentType {
        let viewModel = ErrorViewModel(
            userInterface: errorView,
            localizedError: UIError.genericError,
            actionHandler: action)
        errorView.configure(viewModel: viewModel)
        return viewModel
    }
    
    func showProjectPicker(
        projects: [SimpleProjectRecordDecoder],
        finishHandler: @escaping ProjectPickerCoordinator.CustomFinishHandlerType
    ) {
        self.runProjectPickerFlow(projects: projects, finishHandler: finishHandler)
    }
    
    func dismissView(isTaskChanged: Bool) {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish(isTaskChanged: isTaskChanged)
        }
    }
}

// MARK: - Private
extension WorkTimeCoordinator {
    private func runMainFlow() {
        guard let contentProvider = self.contentProvider else { return }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.workTimeContainer()
            let viewModel = WorkTimeContainerViewModel(
                userInterface: controller,
                coordinator: self,
                contentProvider: contentProvider,
                errorHandler: self.dependencyContainer.errorHandler,
                flowType: self.flowType)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
            if let sourceView = self.sourceView {
                self.showWorkTimeController(controller: self.navigationController, sourceView: sourceView)
            } else {
                self.parentViewController?.present(self.navigationController, animated: true)
            }
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
    
    private func runProjectPickerFlow(
        projects: [SimpleProjectRecordDecoder],
        finishHandler: @escaping ProjectPickerCoordinator.CustomFinishHandlerType
    ) {
        let coordinator = ProjectPickerCoordinator(
            dependencyContainer: self.dependencyContainer,
            parentViewController: self.navigationController,
            projects: projects)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] project in
            self?.remove(child: coordinator)
            finishHandler(project)
        }
    }
    
    private func showWorkTimeController(controller: UIViewController, sourceView: UIView) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 320)
        controller.popoverPresentationController?.permittedArrowDirections = .right
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.sourceRect = CGRect(
            x: sourceView.bounds.minX,
            y: sourceView.bounds.midY,
            width: 0,
            height: 0)
        self.parentViewController?.children.last?.present(controller, animated: true)
    }
    
    private func setUpNativationController() {
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.tintColor = .tint
    }
}
