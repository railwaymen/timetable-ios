//
//  APIClientFactoryMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 22/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class APIClientFactoryMock {
    // MARK: - APIClientFactoryType
    var buildAPIClientReturnValue: ApiClientMock = ApiClientMock()
    private(set) var buildAPIClientParams: [BuildAPIClientParams] = []
    struct BuildAPIClientParams {
        let accessService: AccessServiceApiClientType
        let baseURL: URL
    }
}

// MARK: - APIClientFactoryType
extension APIClientFactoryMock: APIClientFactoryType {
    func buildAPIClient(accessService: AccessServiceApiClientType, baseURL: URL) -> ApiClientType {
        self.buildAPIClientParams.append(BuildAPIClientParams(accessService: accessService, baseURL: baseURL))
        return self.buildAPIClientReturnValue
    }
}
