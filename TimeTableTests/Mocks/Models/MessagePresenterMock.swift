//
//  MessagePresenterMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 03/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class MessagePresenterMock: MessagePresenterType {
    private(set) var message: String?
    
    func presentAlertController(withMessage message: String) {
        self.message = message
    }
}
