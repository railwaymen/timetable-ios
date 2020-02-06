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
        let baseURL: URL
    }
}

// MARK: - APIClientFactoryType
extension APIClientFactoryMock: APIClientFactoryType {
    func buildAPIClient(baseURL: URL) -> ApiClientType {
        self.buildAPIClientParams.append(BuildAPIClientParams(baseURL: baseURL))
        return self.buildAPIClientReturnValue
    }
}
