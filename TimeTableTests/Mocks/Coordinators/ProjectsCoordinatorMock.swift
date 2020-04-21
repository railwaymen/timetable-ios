//
//  ProjectsCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectsCoordinatorMock {
    private(set) var showProfileParams: [ShowProfileParams] = []
    struct ShowProfileParams {}
}

// MARK: - ProjectsCoordinatorType
extension ProjectsCoordinatorMock: ProjectsCoordinatorType {
    func showProfile() {
        self.showProfileParams.append(ShowProfileParams())
    }
}
