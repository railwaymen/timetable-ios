//
//  NewVacationViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class NewVacationViewControllerMock: UIViewController {
    
    // MARK: - NewVacationViewModelOutput
   
    // MARK: - NewVacationViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: NewVacationViewModelType
    }
}

// MARK: - NewVacationViewModelOutput
extension NewVacationViewControllerMock: NewVacationViewModelOutput {}

// MARK: - NewVacationViewControllerType
extension NewVacationViewControllerMock: NewVacationViewControllerType {
    func configure(viewModel: NewVacationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
