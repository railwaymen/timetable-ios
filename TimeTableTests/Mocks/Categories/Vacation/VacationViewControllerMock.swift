//
//  VacationViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class VacationViewControllerMock: UIViewController {
    
    // MARK: - VacationViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    private(set) var showTableViewParams: [ShowTableViewParams] = []
    struct ShowTableViewParams {}
    
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    struct ShowErrorViewParams {}
    
    private(set) var setUpTableHeaderViewParams: [SetUpTableHeaderViewParams] = []
    struct SetUpTableHeaderViewParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isHidden: Bool
    }
    
    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {}
    
    // MARK: - VacationViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: VacationViewModelType
    }
}

// MARK: - VacationViewModelOutput
extension VacationViewControllerMock: VacationViewModelOutput {
    func setUpView() {
        self.setUpParams.append(SetUpParams())
    }

    func showTableView() {
        self.showTableViewParams.append(ShowTableViewParams())
    }
    
    func showErrorView() {
        self.showErrorViewParams.append(ShowErrorViewParams())
    }
    
    func setUpTableHeaderView() {
        self.setUpTableHeaderViewParams.append(SetUpTableHeaderViewParams())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
    
    func updateView() {
        self.updateViewParams.append(UpdateViewParams())
    }
}

// MARK: - VacationViewControllerType
extension VacationViewControllerMock: VacationViewControllerType {
    func configure(viewModel: VacationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
