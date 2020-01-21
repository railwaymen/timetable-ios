//
//  ProjectsViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ProjectsViewControllerMock {
    private(set) var setUpViewParams: [SetUpViewParams] = []
    struct SetUpViewParams {}
    
    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {}
    
    private(set) var showCollectionViewParams: [ShowCollectionViewParams] = []
    struct ShowCollectionViewParams {}
    
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    struct ShowErrorViewParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isHidden: Bool
    }
    
        private(set) var screenOrientationDidChangeParams: [ScreenOrientationDidChangeParams] = []
    struct ScreenOrientationDidChangeParams {}
}

// MARK: - ProjectsViewModelOutput
extension ProjectsViewControllerMock: ProjectsViewModelOutput {
    func setUpView() {
        self.setUpViewParams.append(SetUpViewParams())
    }
    
    func updateView() {
        self.updateViewParams.append(UpdateViewParams())
    }
    
    func showCollectionView() {
        self.showCollectionViewParams.append(ShowCollectionViewParams())
    }
    
    func showErrorView() {
        self.showErrorViewParams.append(ShowErrorViewParams())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
    
    func screenOrientationDidChange() {
        self.screenOrientationDidChangeParams.append(ScreenOrientationDidChangeParams())
    }
}
