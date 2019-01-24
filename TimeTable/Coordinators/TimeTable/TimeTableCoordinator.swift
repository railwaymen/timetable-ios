//
//  TimeTableTabCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias TimeTableTabApiClientType = (ApiClientWorkTimesType & ApiClientProjectsType & ApiClientUsersType)

class TimeTableTabCoordinator: BaseTabBarCoordinator {
    
    // MARK: - Initialization
    init(window: UIWindow?, storyboardsManager: StoryboardsManagerType, apiClient: TimeTableTabApiClientType,
         accessService: AccessServiceUserIDType, coreDataStack: CoreDataStackUserType, errorHandler: ErrorHandlerType) {
        let projectsCoordinator = ProjectsCoordinator(window: nil,
                                                      storyboardsManager: storyboardsManager,
                                                      apiClient: apiClient,
                                                      errorHandler: errorHandler)
        let workTimeCoordinator = WorkTimesCoordinator(window: nil,
                                                      storyboardsManager: storyboardsManager,
                                                      apiClient: apiClient,
                                                      errorHandler: errorHandler)
        let userCoordinator = UserCoordinator(window: nil,
                                              storyboardsManager: storyboardsManager,
                                              apiClient: apiClient,
                                              accessService: accessService,
                                              coreDataStack: coreDataStack,
                                              errorHandler: errorHandler)
        
        super.init(window: window)
        [projectsCoordinator, workTimeCoordinator, userCoordinator].forEach { self.addChildCoordinator(child: $0) }
//        self.tabBarChildCoordinators = [projectsCoordinator, workTimeCoordinator, userCoordinator]
        self.tabBarController.tabBar.tintColor = UIColor.crimson
        
        projectsCoordinator.start()
        workTimeCoordinator.start()
        userCoordinator.start { [weak self] in
            self?.finishCompletion?()
        }
    }
}
