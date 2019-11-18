//
//  NotificationCenterMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class NotificationCenterMock {
    private(set) var removeObserverParams: [RemoveObserverParams] = []
    struct RemoveObserverParams {
        var observer: Any
    }
    
    private(set) var addObserverParams: [AddObserverParams] = []
    struct AddObserverParams {
        var observer: Any
        var selector: Selector
        var name: NSNotification.Name?
        var object: Any?
    }
}

// MARK: - NotificationCenterType
extension NotificationCenterMock: NotificationCenterType {
    func removeObserver(_ observer: Any) {
        self.removeObserverParams.append(RemoveObserverParams(observer: observer))
    }
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        self.addObserverParams.append(AddObserverParams(observer: observer, selector: aSelector, name: aName, object: anObject))
    }
}
