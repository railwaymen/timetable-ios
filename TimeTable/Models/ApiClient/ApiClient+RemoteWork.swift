//
//  ApiClient+RemoteWork.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias RemoteWorkResult = Result<RemoteWorkResponse, Error>
typealias FetchRemoteWorkCompletion = (RemoteWorkResult) -> Void

protocol ApiClientRemoteWorkType: class {
    func fetchRemoteWork(
        parameters: RemoteWorkParameters,
        completion: @escaping FetchRemoteWorkCompletion) -> RestlerTaskType?
}

// MARK: - ApiClientRemoteWorkType
extension ApiClient: ApiClientRemoteWorkType {
    func fetchRemoteWork(
        parameters: RemoteWorkParameters,
        completion: @escaping FetchRemoteWorkCompletion
    ) -> RestlerTaskType? {
        return self.restler
            .get(Endpoint.remoteWorks)
            .query(parameters)
            .decode(RemoteWorkResponse.self)
            .onCompletion(completion)
            .start()
    }
}
