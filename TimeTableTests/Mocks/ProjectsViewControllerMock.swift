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
        self.setUpViewCalled = true
    }
    
    private(set) var updateViewCalled = false
    func updateView() {
        self.updateViewCalled = true
    }
    
    private(set) var showCollectionViewCalled: Bool = false
    func showCollectionView() {
        self.showCollectionViewCalled = true
    }
    
    private(set) var showErrorViewCalled: Bool = false
    func showErrorView() {
        self.showErrorViewCalled = true
    }
    
    private(set) var setActivityIndicatorIsHidden: Bool?
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorIsHidden = isHidden
    }
}
