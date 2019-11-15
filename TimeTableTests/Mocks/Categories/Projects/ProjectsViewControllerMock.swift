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
    private(set) var updateViewParams: [UpdateViewParams] = []
    private(set) var showCollectionViewParams: [ShowCollectionViewParams] = []
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []

    // MARK: - Structures
    struct SetUpViewParams {}
    
    struct UpdateViewParams {}
    
    struct ShowCollectionViewParams {}
    
    struct ShowErrorViewParams {}
    
    struct SetActivityIndicatorParams {
        var isHidden: Bool
    }
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
}
