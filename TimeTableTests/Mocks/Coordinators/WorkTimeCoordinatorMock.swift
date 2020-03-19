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
    
    private(set) var viewDidFinishParams: [ViewDidFinishParams] = []
    struct ViewDidFinishParams {
        var isTaskChanged: Bool
    }
}

// MARK: - WorkTimeCoordinatorType
extension WorkTimeCoordinatorMock: WorkTimeCoordinatorType {
    func showProjectPicker(projects: [SimpleProjectRecordDecoder], finishHandler: @escaping ProjectPickerCoordinator.CustomFinishHandlerType) {
        self.showProjectPickerParams.append(ShowProjectPickerParams(projects: projects, finishHandler: finishHandler))
    }
    
    func viewDidFinish(isTaskChanged: Bool) {
        self.viewDidFinishParams.append(ViewDidFinishParams(isTaskChanged: isTaskChanged))
    }
}
