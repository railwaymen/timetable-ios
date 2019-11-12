//
//  ProjectCollectionViewCellMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import UIKit
@testable import TimeTable

class ProjectCollectionViewCellMock: ProjectCollectionViewCellModelOutput {
    private(set) var setupViewCalled = false
    private(set) var updateViewCalled = false
    // swiftlint:disable large_tuple
    private(set) var updateViewData: (projectName: String?, leaderName: String?, projectColor: UIColor?) = (nil, nil, nil)
    // swiftlint:enable large_tuple
    
    func setupView() {
        self.setupViewCalled = true
    }
    
    func updateView(with projectName: String, leaderName: String, projectColor: UIColor) {
        self.updateViewCalled = true
        self.updateViewData = (projectName, leaderName, projectColor)
    }
}
