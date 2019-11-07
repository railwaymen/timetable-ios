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
        setUpCalledCount += 1
        setUpTitle = title
    }
    
    // MARK: - ProjectPickerCellType
    private(set) var configureCalledCount = 0
    func configure(viewModel: ProjectPickerCellModelType) {
        configureCalledCount += 1
    }
}
