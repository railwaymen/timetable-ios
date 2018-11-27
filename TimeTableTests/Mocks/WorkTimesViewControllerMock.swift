//
//  WorkTimesViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimesViewControllerMock: WorkTimesViewControlleralbe {
    private(set) var setUpViewCalled = false
    private(set) var updateViewCalled = false
    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimesViewModelType?) = (false, nil)
    func setUpView() {
        setUpViewCalled = true
    }
    
    func updateView() {
        updateViewCalled = true
    }
 
    func configure(viewModel: WorkTimesViewModelType) {
        configureViewModelData = (true, viewModel)
    }
}
