//
//  UsedVacationViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class UsedVacationViewControllerMock: UIViewController {
    
    // MARK: - UsedVacationViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    // MARK: - UsedVacationViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: UsedVacationViewModelType
    }
}

// MARK: - UsedVacationViewModelOutput
extension UsedVacationViewControllerMock: UsedVacationViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
}

// MARK: - UsedVacationViewControllerType
extension UsedVacationViewControllerMock: UsedVacationViewControllerType {
    func configure(viewModel: UsedVacationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
