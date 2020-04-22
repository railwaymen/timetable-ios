//
//  VacationsViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class VacationsViewControllerMock: UIViewController {
    
    // MARK: - VacationsViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    // MARK: - VacationsViewContorllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: VacationsViewModelType
    }
}

// MARK: - VacationsViewModelOutput
extension VacationsViewControllerMock: VacationsViewModelOutput {
    func setUpView() {
        self.setUpParams.append(SetUpParams())
    }
}

// MARK: - VacationsViewContorllerType
extension VacationsViewControllerMock: VacationsViewContorllerType {
    func configure(viewModel: VacationsViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
