//
//  MessagePresenterMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 03/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class MessagePresenterMock {
    private(set) var presentAlertControllerParams: [PresentAlertControllerParams] = []
    struct PresentAlertControllerParams {
        var message: String
    }
}

// MARK: - MessagePresenterType
extension MessagePresenterMock: MessagePresenterType {
    func presentAlertController(withMessage message: String) {
        self.presentAlertControllerParams.append(PresentAlertControllerParams(message: message))
    }
}
