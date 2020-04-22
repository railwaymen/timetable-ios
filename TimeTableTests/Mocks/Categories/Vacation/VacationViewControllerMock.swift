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
}

// MARK: - VacationViewControllerType
extension VacationViewControllerMock: VacationViewControllerType {
    func configure(viewModel: VacationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
