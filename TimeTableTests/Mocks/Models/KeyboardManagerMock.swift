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
    
    // MARK: - KeyboardManagerable
    var currentStateReturnValue: KeyboardManager.KeyboardState = .hidden
    
    private(set) var setKeyboardHeightChangeHandlerParams: [SetKeyboardHeightChangeHandlerParams] = []
    struct SetKeyboardHeightChangeHandlerParams {
        let observer: KeyboardManagerObserverable
        let handler: KeyboardManager.StateChangeHandler
    }
    
    private(set) var removeHandlerParams: [RemoveHandlerParams] = []
    struct RemoveHandlerParams {
        let observer: KeyboardManagerObserverable
    }
}

// MARK: - KeyboardManagerable
extension KeyboardManagerMock: KeyboardManagerable {
    var currentState: KeyboardManager.KeyboardState {
        self.currentStateReturnValue
    }
    
    func setKeyboardStateChangeHandler(
        for observer: KeyboardManagerObserverable,
        handler: @escaping KeyboardManager.StateChangeHandler
    ) {
        self.setKeyboardHeightChangeHandlerParams.append(SetKeyboardHeightChangeHandlerParams(
            observer: observer,
            handler: handler))
    }
    
    func removeHandler(for observer: KeyboardManagerObserverable) {
        self.removeHandlerParams.append(RemoveHandlerParams(observer: observer))
    }
}
