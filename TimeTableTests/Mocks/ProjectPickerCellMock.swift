//
//  ProjectPickerCellMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ProjectPickerCellMock: ProjectPickerCellable {
    
    // MARK: - ProjectPickerCellModelOutput
    private(set) var setUpCalledCount = 0
    private(set) var setUpTitle: String?
    func setUp(title: String) {
        self.setUpCalledCount += 1
        self.setUpTitle = title
    }
    
    // MARK: - ProjectPickerCellType
    private(set) var configureCalledCount = 0
    func configure(viewModel: ProjectPickerCellModelType) {
        self.configureCalledCount += 1
    }
}
