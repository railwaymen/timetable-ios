//
//  ApiClient+RemoteWork.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias RemoteWorkResponseResult = Result<RemoteWorkResponse, Error>
typealias FetchRemoteWorkCompletion = (RemoteWorkResponseResult) -> Void

typealias RemoteWorkArrayResult = Result<[RemoteWork], Error>
typealias RegisterRemoteWorkCompletion = (RemoteWorkArrayResult) -> Void

protocol ApiClientRemoteWorkType: class {
    func fetchRemoteWork(
        parameters: RemoteWorkParameters,
        completion: @escaping FetchRemoteWorkCompletion) -> RestlerTaskType?
    func registerRemoteWork(
        parameters: RemoteWorkRequest,
        completion: @escaping RegisterRemoteWorkCompletion) -> RestlerTaskType?
    func deleteRemoteWork(_ remoteWork: RemoteWork, completion: @escaping VoidCompletion) -> RestlerTaskType?
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
    
    func registerRemoteWork(
        parameters: RemoteWorkRequest,
        completion: @escaping RegisterRemoteWorkCompletion
    ) -> RestlerTaskType? {
        self.restler
            .post(Endpoint.remoteWorks)
            .body(parameters)
            .decode([RemoteWork].self)
            .onCompletion(completion)
            .start()
    }
    
    func deleteRemoteWork(_ remoteWork: RemoteWork, completion: @escaping VoidCompletion) -> RestlerTaskType? {
        self.restler
            .delete(Endpoint
            .remoteWork(remoteWork.id))
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
}
