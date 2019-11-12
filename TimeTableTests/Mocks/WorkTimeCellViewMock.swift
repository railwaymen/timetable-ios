//
//  WorkTimeCellViewMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimeCellViewMock: WorkTimeTableViewCellable {
    
    private(set) var setUpCalled = false
    private(set) var updateViewData: WorkTimeCellViewModel.ViewData?
    
    // MARK: - WorkTimeTableViewCellModelOutput
    func setUp() {
        self.setUpCalled = true
    }
    
    func updateView(data: WorkTimeCellViewModel.ViewData) {
        self.updateViewData = data
    }
    
    // MARK: - WorkTimeTableViewCellType
    func configure(viewModel: WorkTimeCellViewModelType) {}
}
