//
//  WorkTimesTableViewHeaderViewMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimesTableViewHeaderViewMock: UITableViewHeaderFooterView {
    private(set) var updateViewParams: [UpdateViewParams] = []
    private(set) var configureParams: [ConfigureParams] = []
    
    // MARK: - Structures
    struct UpdateViewParams {
        var dayText: String?
        var durationText: String?
    }
    
    struct ConfigureParams {
        var viewModel: WorkTimesTableViewHeaderViewModelType
    }
}

// MARK: - WorkTimesTableViewHeaderViewModelOutput
extension WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {
        self.updateViewParams.append(UpdateViewParams(dayText: dayText, durationText: durationText))
    }
}

// MARK: - WorkTimesTableViewHeaderType
extension WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderType {
    func configure(viewModel: WorkTimesTableViewHeaderViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
