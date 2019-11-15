//
//  ProjectPickerCellMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectPickerCellMock: UITableViewCell {
    private(set) var setUpParams: [SetUpParams] = []
    private(set) var configureParams: [ConfigureParams] = []
    
    // MARK: - Structures
    struct SetUpParams {
        var title: String
    }
    
    struct ConfigureParams {
        var viewModel: ProjectPickerCellModelType
    }
}

// MARK: - ProjectPickerCellModelOutput
extension ProjectPickerCellMock: ProjectPickerCellModelOutput {
    func setUp(title: String) {
        self.setUpParams.append(SetUpParams(title: title))
    }
}

// MARK: - ProjectPickerCellType
extension ProjectPickerCellMock: ProjectPickerCellType {
    func configure(viewModel: ProjectPickerCellModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
