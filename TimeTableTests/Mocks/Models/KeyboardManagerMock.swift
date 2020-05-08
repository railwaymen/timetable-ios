//
//  KeyboardManagerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class KeyboardManagerMock {
    
    private(set) var addKeyboardHeightChangeObserverParams: [AddKeyboardHeightChangeObserverParams] = []
    struct AddKeyboardHeightChangeObserverParams {
        let observer: KeyboardManagerObserverable
    }
    
    private(set) var removeObserverParams: [RemoveObserverParams] = []
    struct RemoveObserverParams {
        let observer: KeyboardManagerObserverable
    }
}

// MARK: - KeyboardManagerable
extension KeyboardManagerMock: KeyboardManagerable {
    func addKeyboardHeightChange(observer: KeyboardManagerObserverable) {
        self.addKeyboardHeightChangeObserverParams.append(AddKeyboardHeightChangeObserverParams(observer: observer))
    }
    
    func remove(observer: KeyboardManagerObserverable) {
        self.removeObserverParams.append(RemoveObserverParams(observer: observer))
    }
}
