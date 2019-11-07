//
//  WorkTimeCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimeCoordinatorMock: WorkTimeCoordinatorType {
    private(set) var showProjectPickerCalledCount = 0
    private(set) var showProjectPickerProjects: [ProjectDecoder]?
    private(set) var showProjectPickerFinishHandler: ProjectPickerCoordinator.FinishHandlerType?
    func showProjectPicker(projects: [ProjectDecoder], finishHandler: @escaping ProjectPickerCoordinator.FinishHandlerType) {
        showProjectPickerCalledCount += 1
        showProjectPickerProjects = projects
        showProjectPickerFinishHandler = finishHandler
    }
    
    private(set) var viewDidFinishCalledCount = 0
    private(set) var viewDidFinishIsTaskChanged: Bool?
    func viewDidFinish(isTaskChanged: Bool) {
        viewDidFinishCalledCount += 1
        viewDidFinishIsTaskChanged = isTaskChanged
    }
}
