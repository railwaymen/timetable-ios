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
    struct SetUpParams {}
    
    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {
        var data: WorkTimeCellViewModel.ViewData
    }
    
    private(set) var configureParams: [ConfigureParams] = []
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
