//
//  StoryboardsManagerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class StoryboardsManagerMock {
    var controllerThrownError: Error?
    var controllerReturnValue: UIViewController!
    private(set) var controllerParams: [ControllerParams] = []
    struct ControllerParams {
        let storyboard: StoryboardsManager.StoryboardName
        let controllerIdentifier: StoryboardsManager.ControllerIdentifier
    }
}

// MARK: - StoryboardsManagerType
extension StoryboardsManagerMock: StoryboardsManagerType {
    func controller<T>(
        storyboard: StoryboardsManager.StoryboardName,
        controllerIdentifier: StoryboardsManager.ControllerIdentifier
    ) throws -> T {
        self.controllerParams.append(ControllerParams(storyboard: storyboard, controllerIdentifier: controllerIdentifier))
        if let error = self.controllerThrownError {
            throw error
        }
        return try XCTUnwrap(self.controllerReturnValue as? T)
    }
}
