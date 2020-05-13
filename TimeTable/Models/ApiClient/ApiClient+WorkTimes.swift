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
    func fetchWorkTimes(
        parameters: WorkTimesParameters,
        completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void)) -> RestlerTaskType?
    func fetchWorkTimeDetails(
        id: Int64,
        completion: @escaping (Result<WorkTimeDecoder, Error>) -> Void) -> RestlerTaskType?
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
    func addWorkTimeWithFilling(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteWorkTime(id: Int64, completion: @escaping ((Result<Void, Error>) -> Void))
    func updateWorkTime(id: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
}

extension ApiClient: ApiClientWorkTimesType {
    func fetchWorkTimes(
        parameters: WorkTimesParameters,
        completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void)
    ) -> RestlerTaskType? {
        return self.restler
            .get(Endpoint.workTimes)
            .query(parameters)
            .decode([WorkTimeDecoder].self)
            .onCompletion(completion)
            .start()
    }
    
    func fetchWorkTimeDetails(
        id: Int64,
        completion: @escaping (Result<WorkTimeDecoder, Error>) -> Void
    ) -> RestlerTaskType? {
        return self.restler
            .get(Endpoint.workTime(id))
            .decode(WorkTimeDecoder.self)
            .onCompletion(completion)
            .start()
    }
    
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        _ = self.restler
            .post(Endpoint.workTimes)
            .body(parameters)
            .failureDecode(ValidationError<WorkTimeValidationError>.self)
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
    
    func addWorkTimeWithFilling(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        _ = self.restler
            .post(Endpoint.workTimesCreateWithFilling)
            .body(task)
            .failureDecode(ValidationError<WorkTimeValidationError>.self)
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
    
    func deleteWorkTime(id: Int64, completion: @escaping ((Result<Void, Error>) -> Void)) {
        _ = self.restler
            .delete(Endpoint.workTime(id))
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
    
    func updateWorkTime(id: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        _ = self.restler
            .put(Endpoint.workTime(id))
            .body(parameters)
            .failureDecode(ValidationError<WorkTimeValidationError>.self)
            .decode(Void.self)
            .onCompletion(completion)
            .start()
    }
}
