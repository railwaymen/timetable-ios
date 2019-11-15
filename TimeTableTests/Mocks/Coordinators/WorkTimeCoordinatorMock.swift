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
    private(set) var viewDidFinishParams: [ViewDidFinishParams] = []

    // MARK: - Structures
    struct ShowProjectPickerParams {
        var projects: [ProjectDecoder]
        var finishHandler: ProjectPickerCoordinator.FinishHandlerType
    }
    
    struct ViewDidFinishParams {
        var isTaskChanged: Bool
    }
}

// MARK: - WorkTimeCoordinatorType
extension WorkTimeCoordinatorMock: WorkTimeCoordinatorType {
    func showProjectPicker(projects: [ProjectDecoder], finishHandler: @escaping ProjectPickerCoordinator.FinishHandlerType) {
        self.showProjectPickerParams.append(ShowProjectPickerParams(projects: projects, finishHandler: finishHandler))
    }
    
    func viewDidFinish(isTaskChanged: Bool) {
        self.viewDidFinishParams.append(ViewDidFinishParams(isTaskChanged: isTaskChanged))
    }
}
