//
//  ProjectPickerCoordinatorMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ProjectPickerCoordinatorMock: ProjectPickerCoordinatorType {
    
    private(set) var finishFlowCalledCount = 0
    private(set) var finishFlowProject: ProjectDecoder?
    func finishFlow(project: ProjectDecoder?) {
        finishFlowCalledCount += 1
        finishFlowProject = project
    }
}
