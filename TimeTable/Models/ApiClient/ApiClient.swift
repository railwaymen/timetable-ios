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
    ApiClientSessionType
    & ApiClientWorkTimesType
    & ApiClientProjectsType
    & ApiClientUsersType
    & ApiClientAccountingPeriodsType
    & ApiClientVacationType
    & ApiClientRemoteWorkType

typealias VoidResult = (Result<Void, Error>)
typealias VoidCompletion = (VoidResult) -> Void

class ApiClient {
    var restler: RestlerType {
        self._restler.header["token"] = self.accessService.getUserToken()
        return self._restler
    }
    
    private let _restler: RestlerType
    private let accessService: AccessServiceApiClientType
    
    // MARK: - Initialization
    init(
        restler: RestlerType,
        accessService: AccessServiceApiClientType
    ) {
        self._restler = restler
        self.accessService = accessService
        
        self._restler.header[.contentType] = "application/json"
        self._restler.header[.accept] = "application/json"
        self._restler.errorParser.decode(ApiClientError.self)
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = .never
    }
}
