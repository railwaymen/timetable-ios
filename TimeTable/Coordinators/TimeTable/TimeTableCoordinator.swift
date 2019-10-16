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
    init(window: UIWindow?,
         messagePresenter: MessagePresenterType?,
         storyboardsManager: StoryboardsManagerType,
         apiClient: TimeTableTabApiClientType,
         accessService: AccessServiceUserIDType,
         coreDataStack: CoreDataStackUserType,
         errorHandler: ErrorHandlerType) {
        let projectsCoordinator = ProjectsCoordinator(window: nil,
                                                      messagePresenter: messagePresenter,
                                                      storyboardsManager: storyboardsManager,
                                                      apiClient: apiClient,
                                                      errorHandler: errorHandler)
        let workTimeCoordinator = WorkTimesListCoordinator(window: nil,
                                                           messagePresenter: messagePresenter,
                                                           storyboardsManager: storyboardsManager,
                                                           apiClient: apiClient,
                                                           accessService: accessService,
                                                           errorHandler: errorHandler)
        let userCoordinator = UserCoordinator(window: nil,
                                              messagePresenter: messagePresenter,
                                              storyboardsManager: storyboardsManager,
                                              apiClient: apiClient,
                                              accessService: accessService,
                                              coreDataStack: coreDataStack,
                                              errorHandler: errorHandler)
        
        super.init(window: window, messagePresenter: messagePresenter)
        [projectsCoordinator, workTimeCoordinator, userCoordinator].forEach { self.addChildCoordinator(child: $0) }
        self.tabBarController.tabBar.tintColor = UIColor.crimson
        
        projectsCoordinator.start()
        workTimeCoordinator.start()
        userCoordinator.start { [weak self] in
            self?.finishCompletion?()
        }
    }
}
