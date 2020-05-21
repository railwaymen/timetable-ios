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
    
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    struct ShowErrorViewParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isAnimating: Bool
    }
    
    private(set) var setBottomContentInsetParams: [SetBottomContentInsetParams] = []
    struct SetBottomContentInsetParams {
        let isHidden: Bool
    }

    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {}
    
    private(set) var removeRowsParams: [RemoveRowsParams] = []
    struct RemoveRowsParams {
        let indexPaths: [IndexPath]
    }
    
    var getMaxCellsPerTableHeightReturnValue: Int = 1
    private(set) var getMaxCellsPerTableHeightParams: [GetMaxCellsPerTableHeightParams] = []
    struct GetMaxCellsPerTableHeightParams {}
    
    private(set) var deselectAllRowsParams: [DeselectAllRowsParams] = []
    struct DeselectAllRowsParams {}
    
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
    
    func showErrorView() {
        self.showErrorViewParams.append(ShowErrorViewParams())
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isAnimating: isAnimating))
    }
    
    func setBottomContentInset(isHidden: Bool) {
        self.setBottomContentInsetParams.append(SetBottomContentInsetParams(isHidden: isHidden))
    }
    
    func updateView() {
        self.updateViewParams.append(UpdateViewParams())
    }

    func removeRows(at indexPaths: [IndexPath]) {
        self.removeRowsParams.append(RemoveRowsParams(indexPaths: indexPaths))
    }
    
    func getMaxCellsPerTableHeight() -> Int {
        self.getMaxCellsPerTableHeightParams.append(GetMaxCellsPerTableHeightParams())
        return self.getMaxCellsPerTableHeightReturnValue
    }
    
    func deselectAllRows() {
        self.deselectAllRowsParams.append(DeselectAllRowsParams())
    }
}

// MARK: - RemoteWorkViewControllerType
extension RemoteWorkViewControllerMock: RemoteWorkViewControllerType {
    func configure(viewModel: RemoteWorkViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
