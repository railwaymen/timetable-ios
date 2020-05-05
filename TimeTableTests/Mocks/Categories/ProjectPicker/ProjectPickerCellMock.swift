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
    struct SetUpParams {
        let title: String
        let color: UIColor
    }
    
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: ProjectPickerCellModelType
    }
}

// MARK: - ProjectPickerCellModelOutput
extension ProjectPickerCellMock: ProjectPickerCellModelOutput {
    func setUp(title: String, color: UIColor) {
        self.setUpParams.append(SetUpParams(title: title, color: color))
    }
}

// MARK: - ProjectPickerCellType
extension ProjectPickerCellMock: ProjectPickerCellType {
    func configure(viewModel: ProjectPickerCellModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
