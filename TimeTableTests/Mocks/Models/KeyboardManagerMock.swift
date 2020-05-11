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
    
    private(set) var setKeyboardHeightChangeHandlerParams: [SetKeyboardHeightChangeHandlerParams] = []
    struct SetKeyboardHeightChangeHandlerParams {
        let observer: KeyboardManagerObserverable.Type
        let handler: KeyboardManager.HeightChangeHandler
    }
    
    private(set) var removeHandlerParams: [RemoveHandlerParams] = []
    struct RemoveHandlerParams {
        let observer: KeyboardManagerObserverable.Type
    }
    
}

// MARK: - KeyboardManagerable
extension KeyboardManagerMock: KeyboardManagerable {
    func setKeyboardHeightChangeHandler(
        for observer: KeyboardManagerObserverable.Type,
        handler: @escaping KeyboardManager.HeightChangeHandler
    ) {
        self.setKeyboardHeightChangeHandlerParams.append(SetKeyboardHeightChangeHandlerParams(
            observer: observer,
            handler: handler))
    }
    
    func removeHandler(for observer: KeyboardManagerObserverable.Type) {
        self.removeHandlerParams.append(RemoveHandlerParams(observer: observer))
    }
}
