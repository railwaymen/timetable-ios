//
//  NotificationCenter+Extenison.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol NotificationCenterType: class {
    func removeObserver(_ observer: Any)
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
}

extension NotificationCenter: NotificationCenterType {}
