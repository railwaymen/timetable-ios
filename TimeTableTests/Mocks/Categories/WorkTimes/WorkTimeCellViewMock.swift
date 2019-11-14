//
//  WorkTimeCellViewMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeCellViewMock: UITableViewCell {
    private(set) var setUpParams: [SetUpParams] = []
    private(set) var updateViewParams: [UpdateViewParams] = []
    private(set) var configureParams: [ConfigureParams] = []
    
    // MARK: - Structures
    struct SetUpParams {}
    
    struct UpdateViewParams {
        var data: WorkTimeCellViewModel.ViewData
    }
    
    struct ConfigureParams {
        var viewModel: WorkTimeCellViewModelType
    }
}

// MARK: - WorkTimeCellViewModelOutput
extension WorkTimeCellViewMock: WorkTimeCellViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func updateView(data: WorkTimeCellViewModel.ViewData) {
        self.updateViewParams.append(UpdateViewParams(data: data))
    }
}
    
// MARK: - WorkTimeTableViewCellType
extension WorkTimeCellViewMock: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeCellViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
