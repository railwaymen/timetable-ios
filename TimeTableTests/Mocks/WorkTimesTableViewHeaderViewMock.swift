//
//  WorkTimesTableViewHeaderViewMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimesTableViewHeaderViewMock: WorkTimesTableViewHeaderable {
    
    private(set) var updateViewData: (dayText: String?, durationText: String?)?
    
    // MARK: - WorkTimesTableViewHeaderViewModelOutput
    func updateView(dayText: String?, durationText: String?) {
        self.updateViewData = (dayText, durationText)
    }
    // MARK: - WorkTimesTableViewHeaderType
    func configure(viewModel: WorkTimesTableViewHeaderViewModelType) {}
}
