//
//  RemoteWorkCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol RemoteWorkCoordinatorType: class {
    func remoteWorkDidRequestForProfileView()
    func remoteWorkDidRequestForFormView(finishHandler: @escaping ([RemoteWork]) -> Void)
}

class RemoteWorkCoordinator: NavigationCoordinator, TabBarChildCoordinatorType {
    private let dependencyContainer: DependencyContainerType
    
    let tabBarItem: UITabBarItem
    
    var root: UIViewController {
        return self.navigationController
    }
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        self.tabBarItem = UITabBarItem(
            title: R.string.localizable.remotework_title(),
            image: #imageLiteral(resourceName: "tab_bar_remote_work_icon"),
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

// MARK: - RemoteWorkCoordinatorType
extension RemoteWorkCoordinator: RemoteWorkCoordinatorType {
    func remoteWorkDidRequestForProfileView() {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        self.dependencyContainer.parentCoordinator?.showProfile(parentViewController: parentViewController)
    }
    
    func remoteWorkDidRequestForFormView(finishHandler: @escaping ([RemoteWork]) -> Void) {
        let parentViewController = self.navigationController.topViewController ?? self.navigationController
        let coordinator = RegisterRemoteWorkCoordinator(
            dependencyContainer: self.dependencyContainer,
            parentViewController: parentViewController)
        self.add(child: coordinator)
        coordinator.start { [weak self, weak coordinator] response in
            self?.remove(child: coordinator)
            finishHandler(response)
        }
    }
}

// MARK: - Private
extension RemoteWorkCoordinator {
    private func runMainFlow() {
        guard let apiClient = self.dependencyContainer.apiClient else {
            self.dependencyContainer.errorHandler.stopInDebug("Api client is nil")
            return
        }
        do {
            let controller = try self.dependencyContainer.viewControllerBuilder.remoteWork()
            let viewModel = RemoteWorkViewModel(
                userInterface: controller,
                coordinator: self,
                apiClient: apiClient,
                errorHandler: self.dependencyContainer.errorHandler)
            controller.configure(viewModel: viewModel)
            self.navigationController.setViewControllers([controller], animated: false)
        } catch {
            self.dependencyContainer.errorHandler.stopInDebug("\(error)")
        }
    }
}
