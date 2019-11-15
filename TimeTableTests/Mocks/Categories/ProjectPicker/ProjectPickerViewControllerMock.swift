//
//  ProjectPickerViewControllerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectPickerViewControllerMock {
    private(set) var setUpParams: [SetUpParams] = []
    private(set) var reloadDataParams: [ReloadDataParams] = []
    private(set) var setBottomContentInsetsParams: [SetBottomContentInsetsParams] = []
    private(set) var configureParams: [ConfigureParams] = []
    
    // MARK: - Structures
    struct SetUpParams {}
    
    struct ReloadDataParams {}
    
    struct SetBottomContentInsetsParams {
        var inset: CGFloat
    }
    
    struct ConfigureParams {
        var viewModel: ProjectPickerViewModelType
    }
}

// MARK: - ProjectPickerViewModelOutput
extension ProjectPickerViewControllerMock: ProjectPickerViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func reloadData() {
        self.reloadDataParams.append(ReloadDataParams())
    }
    
    func setBottomContentInsets(_ inset: CGFloat) {
        self.setBottomContentInsetsParams.append(SetBottomContentInsetsParams(inset: inset))
    }
}

// MARK: - ProjectPickerViewControllerType
extension ProjectPickerViewControllerMock: ProjectPickerViewControllerType {
    func configure(viewModel: ProjectPickerViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
