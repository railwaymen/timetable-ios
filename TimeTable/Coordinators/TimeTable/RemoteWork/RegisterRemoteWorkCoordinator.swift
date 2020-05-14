//
//  RegisterRemoteWorkCoordinator.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol RegisterRemoteWorkCoordinatorType: class {
    func registerRemoteWorkDidRequestToDismiss()
    func registerRemoteWorkDidFinish(response: [RemoteWork])
}

class RegisterRemoteWorkCoordinator: NavigationCoordinator {
    private weak var parentViewController: UIViewController?
    private let dependencyContainer: DependencyContainerType
    private let mode: RegisterRemoteWorkViewModel.Mode
    private var customFinishCompletion: (([RemoteWork]) -> Void)?
    
    // MARK: - Initialization
    init(
        dependencyContainer: DependencyContainerType,
        parentViewController: UIViewController,
        mode: RegisterRemoteWorkViewModel.Mode
    ) {
        self.dependencyContainer = dependencyContainer
        self.parentViewController = parentViewController
        self.mode = mode
        super.init(window: dependencyContainer.window)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.navigationBar.prefersLargeTitles = false
        self.navigationController.navigationBar.tintColor = .tint
    }
    
    deinit {
        self.navigationController.setViewControllers([], animated: false)
    }
    
    // MARK: - Overridden
    override func finish() {
        self.customFinishCompletion?([])
        super.finish()
    }
    
    // MARK: - Internal
    func start(finishHandler: @escaping ([RemoteWork]) -> Void) {
        self.customFinishCompletion = finishHandler
        super.start()
        self.runMainFlow()
    }
    
    func finish(response: [RemoteWork]) {
        self.customFinishCompletion?(response)
        super.finish()
    }
}

// MARK: - RegisterRemoteWorkCoordinatorType
extension RegisterRemoteWorkCoordinator: RegisterRemoteWorkCoordinatorType {
    func registerRemoteWorkDidRequestToDismiss() {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
    
    func registerRemoteWorkDidFinish(response: [RemoteWork]) {
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.finish(response: response)
        }
    }
}

// MARK: - Private
extension RegisterRemoteWorkCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.registerRemoteWork()
            let viewModel = RegisterRemoteWorkViewModel(
                userInterface: controller,
                coordinator: self,
                apiClient: apiClient,
                errorHandler: self.dependencyContainer.errorHandler,
                keyboardManager: self.dependencyContainer.keyboardManager,
                mode: self.mode)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
            self.parentViewController?.present(self.navigationController, animated: true)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
