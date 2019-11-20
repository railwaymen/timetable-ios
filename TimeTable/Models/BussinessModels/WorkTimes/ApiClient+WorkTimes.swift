//
//  ApiClient+WorkTimes.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientWorkTimesType: class {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void))
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void, Error>) -> Void))
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void))
}

extension ApiClient: ApiClientWorkTimesType {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void)) {
        self.get(.workTimes, parameters: parameters, completion: completion)
    }
    
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.post(.workTimes, parameters: parameters, completion: completion)
    }
    
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.delete(.workTime(identifier), completion: completion)
    }
    
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.put(.workTime(identifier), parameters: parameters, completion: completion)
    }
}
