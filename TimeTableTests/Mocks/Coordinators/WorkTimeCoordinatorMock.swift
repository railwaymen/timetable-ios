//
//  WorkTimeCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimeCoordinatorMock {
    var configureContentViewControllerReturnValue: WorkTimeContainerContentType?
    private(set) var configureContentViewControllerParams: [ConfigureContentViewControllerParams] = []
    struct ConfigureContentViewControllerParams {
        let viewController: WorkTimeViewControllerable
    }
    
    var configureErrorViewReturnValue: ErrorViewModelParentType?
    private(set) var configureErrorViewParams: [ConfigureErrorViewParams] = []
    struct ConfigureErrorViewParams {
        let errorView: ErrorViewable
        let action: () -> Void
    }
    
    private(set) var showProjectPickerParams: [ShowProjectPickerParams] = []
    struct ShowProjectPickerParams {
        var projects: [SimpleProjectRecordDecoder]
        var finishHandler: ProjectPickerCoordinator.CustomFinishHandlerType
    }
    
    private(set) var dismissViewParams: [DismissViewParams] = []
    struct DismissViewParams {
        var isTaskChanged: Bool
    }
}

// MARK: - WorkTimeCoordinatorType
extension WorkTimeCoordinatorMock: WorkTimeCoordinatorType {
    func configure(contentViewController: WorkTimeViewControllerable) -> WorkTimeContainerContentType? {
        self.configureContentViewControllerParams.append(ConfigureContentViewControllerParams(
            viewController: contentViewController))
        return self.configureContentViewControllerReturnValue
    }
    
    func configure(errorView: ErrorViewable, action: @escaping () -> Void) -> ErrorViewModelParentType {
        self.configureErrorViewParams.append(ConfigureErrorViewParams(errorView: errorView, action: action))
        return self.configureErrorViewReturnValue
            ?? ErrorViewModel(userInterface: errorView, error: UIError.genericError, actionHandler: action)
    }
    
    func showProjectPicker(
        projects: [SimpleProjectRecordDecoder],
        finishHandler: @escaping ProjectPickerCoordinator.CustomFinishHandlerType
    ) {
        self.showProjectPickerParams.append(ShowProjectPickerParams(projects: projects, finishHandler: finishHandler))
    }
    
    func dismissView(isTaskChanged: Bool) {
        self.dismissViewParams.append(DismissViewParams(isTaskChanged: isTaskChanged))
    }
}
