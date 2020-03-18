//
//  TaskHistoryViewControllerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 18/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskHistoryViewControllerMock {
    
    // MARK: - TaskHistoryViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    private(set) var reloadDataParams: [ReloadDataParams] = []
    struct ReloadDataParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isHidden: Bool
    }
    
    // MARK: - TaskHistoryViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: TaskHistoryViewModelType
    }
}

// MARK: - TaskHistoryViewModelOutput
extension TaskHistoryViewControllerMock: TaskHistoryViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func reloadData() {
        self.reloadDataParams.append(ReloadDataParams())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
}

// MARK: - TaskHistoryViewControllerType
extension TaskHistoryViewControllerMock: TaskHistoryViewControllerType {
    func configure(viewModel: TaskHistoryViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
