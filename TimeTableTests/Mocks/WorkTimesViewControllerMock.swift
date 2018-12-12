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
    private(set) var setUpViewDateString: String?
    private(set) var updateViewCalled = false
    private(set) var updateDateLabelCalled = false
    private(set) var updateDateLabelText: String?
    private(set) var configureViewModelData: (called: Bool, viewModel: WorkTimesViewModelType?) = (false, nil)
    
    func setUpView(with dateString: String) {
        setUpViewCalled = true
        setUpViewDateString = dateString
    }
    
    func updateView() {
        updateViewCalled = true
    }

    func updateDateLabel(text: String) {
        updateDateLabelCalled = true
        updateDateLabelText = text
    }
 
    func configure(viewModel: WorkTimesViewModelType) {
        configureViewModelData = (true, viewModel)
    }
}
