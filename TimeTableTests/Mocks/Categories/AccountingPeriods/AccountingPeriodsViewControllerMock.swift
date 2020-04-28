//
//  AccountingPeriodsViewControllerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AccountingPeriodsViewControllerMock: UIViewController {
    
    // MARK: - AccountingPeriodsViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    private(set) var showListParams: [ShowListParams] = []
    struct ShowListParams {}
    
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    struct ShowErrorViewParams {}
    
    private(set) var reloadDataParams: [ReloadDataParams] = []
    struct ReloadDataParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isHidden: Bool
    }
    
    // MARK: - AccountingPeriodsViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: AccountingPeriodsViewModelType
    }
}

// MARK: - AccountingPeriodsViewModelOutput
extension AccountingPeriodsViewControllerMock: AccountingPeriodsViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func showList() {
        self.showListParams.append(ShowListParams())
    }
    
    func showErrorView() {
        self.showErrorViewParams.append(ShowErrorViewParams())
    }
    
    func reloadData() {
        self.reloadDataParams.append(ReloadDataParams())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
}

// MARK: - AccountingPeriodsViewControllerType
extension AccountingPeriodsViewControllerMock: AccountingPeriodsViewControllerType {
    func configure(viewModel: AccountingPeriodsViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
