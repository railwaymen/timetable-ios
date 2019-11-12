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
    
    // MARK: - WorkTimeTableViewCellModelOutput
    func setUp() {}
    
    func updateView(data: WorkTimeCellViewModel.ViewData) {}
    
    // MARK: - WorkTimeTableViewCellType
    func configure(viewModel: WorkTimeCellViewModelType) {}
}
