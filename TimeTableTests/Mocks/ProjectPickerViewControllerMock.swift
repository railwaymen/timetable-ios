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
        configureCalledCount += 1
    }
    
    // MARK: - ProjectPickerViewModelOutput
    private(set) var setUpCalledCount = 0
    func setUp() {
        setUpCalledCount += 1
    }
    
    private(set) var reloadDataCalledCount = 0
    func reloadData() {
        reloadDataCalledCount += 1
    }
    
    private(set) var setBottomContentInsetsCalledCount = 0
    private(set) var setBottomContentInsetsInsets: CGFloat?
    func setBottomContentInsets(_ inset: CGFloat) {
        setBottomContentInsetsCalledCount += 1
        setBottomContentInsetsInsets = inset
    }
}
