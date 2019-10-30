//
//  TimeTableTabCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias TimeTableTabApiClientType = (ApiClientWorkTimesType & ApiClientProjectsType & ApiClientUsersType & ApiClientMatchingFullTimeType)

class TimeTableTabCoordinator: BaseTabBarCoordinator {
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        let projectsCoordinator = ProjectsCoordinator(dependencyContainer: dependencyContainer)
        let workTimeCoordinator = WorkTimesListCoordinator(dependencyContainer: dependencyContainer)
        let userCoordinator = ProfileCoordinator(dependencyContainer: dependencyContainer)
        
        super.init(window: dependencyContainer.window, messagePresenter: dependencyContainer.messagePresenter)
        [projectsCoordinator, workTimeCoordinator, userCoordinator].forEach { addChildCoordinator(child: $0) }
        tabBarController.tabBar.tintColor = .crimson
        
        projectsCoordinator.start()
        workTimeCoordinator.start()
        userCoordinator.start { [weak self] in
            self?.finishCompletion?()
        }
    }
}
