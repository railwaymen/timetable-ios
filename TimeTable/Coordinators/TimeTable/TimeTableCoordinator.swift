//
//  TimeTableTabCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class TimeTableTabCoordinator: BaseTabBarCoordinator {

    private let tabBarChildCoordinators: [BaseTabBarCordninatorType]
    
    override init(window: UIWindow?) {
        let projectsCoordinator = ProjectsCoordinator(window: nil)
        let workTimeCoordinator = WorkTimeCoordinator(window: nil)
        let userCoordinator = UserCoordinator(window: nil)
        
        self.tabBarChildCoordinators = [projectsCoordinator, workTimeCoordinator, userCoordinator]
        super.init(window: window)
        self.tabBarChildCoordinators.forEach { $0.start() }
    }
    
    override func start(finishCompletion: (() -> Void)?) {
        self.tabBarController.viewControllers = self.tabBarChildCoordinators.map { $0.root }
        super.start(finishCompletion: finishCompletion)
    }
}
