//
//  ProjectPickerViewControllerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectPickerViewControllerMock: ProjectPickerViewControllerable {
    
    // MARK: - ProjectPickerViewControllerType
    private(set) var configureCalledCount = 0
    func configure(viewModel: ProjectPickerViewModelType) {
        self.configureCalledCount += 1
    }
    
    // MARK: - ProjectPickerViewModelOutput
    private(set) var setUpCalledCount = 0
    func setUp() {
        self.setUpCalledCount += 1
    }
    
    private(set) var reloadDataCalledCount = 0
    func reloadData() {
        self.reloadDataCalledCount += 1
    }
    
    private(set) var setBottomContentInsetsCalledCount = 0
    private(set) var setBottomContentInsetsInsets: CGFloat?
    func setBottomContentInsets(_ inset: CGFloat) {
        self.setBottomContentInsetsCalledCount += 1
        self.setBottomContentInsetsInsets = inset
    }
}
