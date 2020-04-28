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
}

// MARK: - AccountingPeriodsViewControllerType
extension AccountingPeriodsViewControllerMock: AccountingPeriodsViewControllerType {
    func configure(viewModel: AccountingPeriodsViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
