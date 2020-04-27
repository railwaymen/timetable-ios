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
}

// MARK: - AccountingPeriodsViewControllerType
extension AccountingPeriodsViewControllerMock: AccountingPeriodsViewControllerType {
    func configure(viewModel: AccountingPeriodsViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
