//
//  ServerConfigurationManagerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ServerConfigurationManagerMock: ServerConfigurationManagerType {
    
    var expectationHandler: (() -> Void)?
    var oldConfiguration: ServerConfiguration?
    private(set) var oldConfigurationCalled = false
    private(set) var verifyConfigurationValues: (called: Bool, configuration: ServerConfiguration?) = (false, nil)
    private(set) var verifyConfigurationCompletion: ((Result<Void>) -> Void)?
    
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void)) {
        verifyConfigurationValues = (true, configuration)
        self.verifyConfigurationCompletion = completion
        expectationHandler?()
    }
    
    func getOldConfiguration() -> ServerConfiguration? {
        oldConfigurationCalled = true
        return oldConfiguration
    }
}
