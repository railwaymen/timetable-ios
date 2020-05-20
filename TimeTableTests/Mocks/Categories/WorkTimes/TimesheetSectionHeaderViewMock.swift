//
//  TimesheetSectionHeaderViewMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TimesheetSectionHeaderViewMock {
    
    // MARK: - TimesheetSectionHeaderViewModelOutput
    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {
        var dayText: String?
        var durationText: String?
    }
    
    // MARK: - TimesheetSectionHeaderViewType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: TimesheetSectionHeaderViewModelType
    }
}

// MARK: - TimesheetSectionHeaderViewModelOutput
extension TimesheetSectionHeaderViewMock: TimesheetSectionHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {
        self.updateViewParams.append(UpdateViewParams(dayText: dayText, durationText: durationText))
    }
}

// MARK: - TimesheetSectionHeaderViewType
extension TimesheetSectionHeaderViewMock: TimesheetSectionHeaderViewType {
    func configure(viewModel: TimesheetSectionHeaderViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
