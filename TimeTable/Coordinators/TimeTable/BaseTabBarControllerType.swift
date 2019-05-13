//
//  File.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 20/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol BaseTabBarCoordinatorType: class {
    var root: UIViewController { get }
    var tabBarItem: UITabBarItem { get }
    
    func start()
    func finish()
}
