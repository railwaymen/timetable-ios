//
//  TimeTableTabCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class TimeTableTabCoordinator: TabBarCoordinator {
    
    // MARK: - Initialization
    init(dependencyContainer: DependencyContainerType) {
        super.init(window: dependencyContainer.window)
        
        let projectsCoordinator = ProjectsCoordinator(dependencyContainer: dependencyContainer)
        let workTimeCoordinator = TimesheetCoordinator(dependencyContainer: dependencyContainer)
        let vacationCoordinator = VacationCoordinator(dependencyContainer: dependencyContainer)
        let remoteWorkCoordinator = RemoteWorkCoordinator(dependencyContainer: dependencyContainer)
        
        self.tabBarController.tabBar.tintColor = .tint
        dependencyContainer.window?.rootViewController = self.tabBarController
        let children = [
            projectsCoordinator,
            workTimeCoordinator,
            vacationCoordinator,
            remoteWorkCoordinator
        ]
        children.forEach {
            self.add(child: $0)
            $0.start()
        }
    }
}

// MARK: - ProfileCoordinatorParentType
extension TimeTableTabCoordinator: ProfileCoordinatorParentType {
    func childDidRequestToFinish() {
        self.finish()
    }
}
