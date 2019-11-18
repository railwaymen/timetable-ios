//
//  ServerConfigurationManagerMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ServerConfigurationManagerMock {

    var getOldConfigurationReturnValue: ServerConfiguration?
    private(set) var getOldConfigurationParams: [GetOldConfigurationParams] = []
    struct GetOldConfigurationParams {}
    
    private(set) var verifyParams: [VerifyParams] = []
    struct VerifyParams {
        var configuration: ServerConfiguration
        var completion: ((Result<Void>) -> Void)
    }
}

// MARK: - ServerConfigurationManagerType
extension ServerConfigurationManagerMock: ServerConfigurationManagerType {
    func getOldConfiguration() -> ServerConfiguration? {
        self.getOldConfigurationParams.append(GetOldConfigurationParams())
        return self.getOldConfigurationReturnValue
    }
    
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void)) {
        self.verifyParams.append(VerifyParams(configuration: configuration, completion: completion))
    }
}
