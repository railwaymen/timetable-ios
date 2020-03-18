//
//  ApiClient+WorkTimes.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Restler

protocol ApiClientWorkTimesType: class {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void)) -> RestlerTaskType?
    func fetchWorkTimeDetails(identifier: Int64, completion: @escaping (Result<WorkTimeDecoder, Error>) -> Void) -> RestlerTaskType?
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void, Error>) -> Void))
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
}

extension ApiClient: ApiClientWorkTimesType {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void)) -> RestlerTaskType? {
        return self.restler
            .get(Endpoint.workTimes)
            .query(parameters)
            .decode([WorkTimeDecoder].self)
            .onCompletion(completion)
            .start()
    }
    
    func fetchWorkTimeDetails(identifier: Int64, completion: @escaping (Result<WorkTimeDecoder, Error>) -> Void) -> RestlerTaskType? {
        return self.restler
            .get(Endpoint.workTime(identifier))
            .decode(WorkTimeDecoder.self)
            .onCompletion(completion)
            .start()
    }
    
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        _ = self.restler
            .post(Endpoint.workTimes)
            .body(parameters)
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
    
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void, Error>) -> Void)) {
        _ = self.restler
            .delete(Endpoint.workTime(identifier))
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
    
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        _ = self.restler
            .put(Endpoint.workTime(identifier))
            .body(parameters)
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
}
