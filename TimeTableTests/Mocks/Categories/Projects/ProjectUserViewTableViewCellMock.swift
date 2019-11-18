//
//  ProjectUserViewTableViewCellMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectUserViewTableViewCellMock {
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var name: String
    }
}

// MARK: - ProjectUserViewTableViewCellType
extension ProjectUserViewTableViewCellMock: ProjectUserViewTableViewCellType {
    func configure(withName name: String) {
        self.configureParams.append(ConfigureParams(name: name))
    }
}
