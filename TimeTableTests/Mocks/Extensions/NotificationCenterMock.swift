//
//  NotificationCenterMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 30/10/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class NotificationCenterMock: NotificationCenterType {
    
    private(set) var removeObserverCalled: Bool = false
    func removeObserver(_ observer: Any) {
        self.removeObserverCalled = true
    }
    
    private(set) var addObserverCalled: Bool = false
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        self.addObserverCalled = true
    }
}
