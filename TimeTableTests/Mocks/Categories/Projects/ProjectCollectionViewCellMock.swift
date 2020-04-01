//
//  ProjectCollectionViewCellMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectCollectionViewCellMock {
    private(set) var setUpViewParams: [SetUpViewParams] = []
    struct SetUpViewParams {}
    
    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {
        var projectName: String
        var leaderName: String
        var projectColor: UIColor
    }
}

// MARK: - ProjectCollectionViewCellModelOutput
extension ProjectCollectionViewCellMock: ProjectCollectionViewCellModelOutput {
    func setUpView() {
        self.setUpViewParams.append(SetUpViewParams())
    }
    
    func updateView(with projectName: String, leaderName: String, projectColor: UIColor) {
        self.updateViewParams.append(UpdateViewParams(
            projectName: projectName,
            leaderName: leaderName,
            projectColor: projectColor))
    }
}
