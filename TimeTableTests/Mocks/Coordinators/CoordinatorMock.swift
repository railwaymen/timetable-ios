//
//  CoordinatorMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class CoordinatorMock {
    private(set) var serverConfigurationDidFinishParams: [ServerConfigurationDidFinishParams] = []
    struct ServerConfigurationDidFinishParams {
        var serverConfiguration: ServerConfiguration
    }
}

// MARK: - ServerConfigurationCoordinatorDelegate
extension CoordinatorMock: ServerConfigurationCoordinatorDelegate {
    func serverConfigurationDidFinish(with serverConfiguration: ServerConfiguration) {
        self.serverConfigurationDidFinishParams.append(ServerConfigurationDidFinishParams(serverConfiguration: serverConfiguration))
    }
}
