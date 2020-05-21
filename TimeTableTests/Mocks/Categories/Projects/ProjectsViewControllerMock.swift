//
//  ProjectsViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectsViewControllerMock: UIViewController {
    
    // MARK: - ProjectsViewModelOutput
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
        let isAnimating: Bool
    }
    
    private(set) var screenOrientationDidChangeParams: [ScreenOrientationDidChangeParams] = []
    struct ScreenOrientationDidChangeParams {}
    
    // MARK: - ProjectsViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: ProjectsViewModelType
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
    
    func setActivityIndicator(isAnimating: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isAnimating: isAnimating))
    }
    
    func screenOrientationDidChange() {
        self.screenOrientationDidChangeParams.append(ScreenOrientationDidChangeParams())
    }
}

// MARK: - ProjectsViewControllerType
extension ProjectsViewControllerMock: ProjectsViewControllerType {
    func configure(viewModel: ProjectsViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
