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
    
    private(set) var showTableViewParams: [ShowTableViewParams] = []
    struct ShowTableViewParams {}
    
    private(set) var showErrorViewParams: [ShowErrorViewParams] = []
    struct ShowErrorViewParams {}
    
    private(set) var setUpTableHeaderViewParams: [SetUpTableHeaderViewParams] = []
    struct SetUpTableHeaderViewParams {}
    
    private(set) var setActivityIndicatorParams: [SetActivityIndicatorParams] = []
    struct SetActivityIndicatorParams {
        let isAnimating: Bool
    }
    
    private(set) var updateViewParams: [UpdateViewParams] = []
    struct UpdateViewParams {}
    
    private(set) var keyboardStateDidChangeParams: [KeyboardStateDidChangeParams] = []
    struct KeyboardStateDidChangeParams {
        let keyboardState: KeyboardManager.KeyboardState
    }
    
    private(set) var dismissKeyboardParams: [DismissKeyboardParams] = []
    struct DismissKeyboardParams {}
    
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

    func showTableView() {
        self.showTableViewParams.append(ShowTableViewParams())
    }
    
    func showErrorView() {
        self.showErrorViewParams.append(ShowErrorViewParams())
    }
    
    func setUpTableHeaderView() {
        self.setUpTableHeaderViewParams.append(SetUpTableHeaderViewParams())
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.setActivityIndicatorParams.append(SetActivityIndicatorParams(isAnimating: isAnimating))
    }
    
    func updateView() {
        self.updateViewParams.append(UpdateViewParams())
    }
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        self.keyboardStateDidChangeParams.append(KeyboardStateDidChangeParams(keyboardState: keyboardState))
    }
    
    func dismissKeyboard() {
        self.dismissKeyboardParams.append(DismissKeyboardParams())
    }
}

// MARK: - VacationViewControllerType
extension VacationViewControllerMock: VacationViewControllerType {
    func configure(viewModel: VacationViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
