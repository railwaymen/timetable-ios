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
    func showProjectPicker(projects: [SimpleProjectRecordDecoder], finishHandler: @escaping ProjectPickerCoordinator.CustomFinishHandlerType) {
        self.showProjectPickerParams.append(ShowProjectPickerParams(projects: projects, finishHandler: finishHandler))
    }
    
    func dismissView(isTaskChanged: Bool) {
        self.dismissViewParams.append(DismissViewParams(isTaskChanged: isTaskChanged))
    }
}
