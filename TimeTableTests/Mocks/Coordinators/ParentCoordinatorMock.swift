//
//  ParentCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ParentCoordinatorMock {
    private(set) var presentErrorParams: [PresentErrorParams] = []
    struct PresentErrorParams {
        let error: Error
    }
    
    private(set) var showProfileParams: [ShowProfileParams] = []
    struct ShowProfileParams {
        let parentViewController: UIViewController
    }
}

// MARK: - ParentCoordinator
extension ParentCoordinatorMock: ParentCoordinator {
    func present(error: Error) {
        self.presentErrorParams.append(PresentErrorParams(error: error))
    }
    
    func showProfile(parentViewController: UIViewController) {
        self.showProfileParams.append(ShowProfileParams(parentViewController: parentViewController))
    }
}
