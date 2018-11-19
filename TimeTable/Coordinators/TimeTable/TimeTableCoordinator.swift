//
//  TimeTableCoordinator.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

class TimeTableCoordinator: BaseCoordinator {

    private let tabBarController: UITabBarController

    override init(window: UIWindow?) {
        tabBarController = UITabBarController()
        super.init(window: window)
    }
    
    override func start(finishCompletion: (() -> Void)?) {        
        window?.rootViewController = tabBarController
        super.start(finishCompletion: finishCompletion)
    }
}
