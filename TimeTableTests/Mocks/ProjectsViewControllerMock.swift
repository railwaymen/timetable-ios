//
//  ProjectsViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ProjectsViewControllerMock: ProjectsViewModelOutput {
    
    private(set) var setUpViewCalled = false
    func setUpView() {
        setUpViewCalled = true
    }
    
    private(set) var updateViewCalled = false
    func updateView() {
        updateViewCalled = true
    }
    
    private(set) var setActivityIndicatorIsHidden: Bool?
    func setActivityIndicator(isHidden: Bool) {
        setActivityIndicatorIsHidden = isHidden
    }
}
