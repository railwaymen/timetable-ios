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
        let isAnimating: Bool
    }
    
    private(set) var setBottomContentInsetParams: [SetBottomContentInsetParams] = []
    struct SetBottomContentInsetParams {
        let isHidden: Bool
    }
    
    var getMaxCellsPerPageReturnValue: Int = 0
    private(set) var getMaxCellsPerPageParams: [GetMaxCellsPerPageParams] = []
    struct GetMaxCellsPerPageParams {}
    
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
    
    func setActivityIndicator(isAnimating: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isAnimating: isAnimating))
    }
    
    func setBottomContentInset(isHidden: Bool) {
        self.setBottomContentInsetParams.append(SetBottomContentInsetParams(isHidden: isHidden))
    }
    
    func getMaxCellsCountPerTableHeight() -> Int {
        self.getMaxCellsPerPageParams.append(GetMaxCellsPerPageParams())
        return self.getMaxCellsPerPageReturnValue
    }
}

// MARK: - AccountingPeriodsViewControllerType
extension AccountingPeriodsViewControllerMock: AccountingPeriodsViewControllerType {
    func configure(viewModel: AccountingPeriodsViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
