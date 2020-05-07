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
    
    // MARK: - RemoteWorkViewModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    private(set) var showTableViewParams: [ShowTableViewParams] = []
    struct ShowTableViewParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isHidden: Bool
    }

    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {}
    
    var getMaxCellsPerTableHeightReturnValue: Int = 1
    private(set) var getMaxCellsPerTableHeightParams: [GetMaxCellsPerTableHeightParams] = []
    struct GetMaxCellsPerTableHeightParams {}
    
    // MARK: - RemoteWorkViewControllerType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        let viewModel: RemoteWorkViewModelType
    }
}

// MARK: - RemoteWorkViewModelOutput
extension RemoteWorkViewControllerMock: RemoteWorkViewModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func showTableView() {
        self.showTableViewParams.append(ShowTableViewParams())
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isHidden: isHidden))
    }
    
    func updateView() {
        self.updateViewParams.append(UpdateViewParams())
    }
    
    func getMaxCellsPerTableHeight() -> Int {
        self.getMaxCellsPerTableHeightParams.append(GetMaxCellsPerTableHeightParams())
        return self.getMaxCellsPerTableHeightReturnValue
    }
}

// MARK: - RemoteWorkViewControllerType
extension RemoteWorkViewControllerMock: RemoteWorkViewControllerType {
    func configure(viewModel: RemoteWorkViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
