//
//  ApiClient.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias ApiClientType =
    ApiClientNetworkingType
    & ApiClientSessionType
    & ApiClientWorkTimesType
    & ApiClientProjectsType
    & ApiClientUsersType
    & ApiClientMatchingFullTimeType

typealias ApiClientProfileType =
    ApiClientUsersType
    & ApiClientNetworkingType

protocol ApiClientNetworkingType: class {
    func setAuthenticationToken(_ token: String)
    func removeAuthenticationToken()
}

class ApiClient {
    let restler: RestlerType
    
    // MARK: - Initialization
    init(restler: RestlerType) {
        self.restler = restler
        
        self.restler.header[.contentType] = "application/json"
        self.restler.errorParser.decode(ApiClientError.self)
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = .never
    }
}

// MARK: - ApiClientNetworkingType
extension ApiClient: ApiClientNetworkingType {
    func setAuthenticationToken(_ token: String) {
        self.restler.header["token"] = token
    }
    
    func removeAuthenticationToken() {
        self.restler.header["token"] = nil
    }
}
