//
//  RemoteWorkViewControllerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RemoteWorkViewControllerMock: UIViewController {
    
    // MARK: - RemoteWorkViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: RemoteWorkViewModelType
    }
}

// MARK: - RemoteWorkViewModelOutput
extension RemoteWorkViewControllerMock: RemoteWorkViewModelOutput {}

// MARK: - RemoteWorkViewControllerType
extension RemoteWorkViewControllerMock: RemoteWorkViewControllerType {
    func configure(viewModel: RemoteWorkViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
