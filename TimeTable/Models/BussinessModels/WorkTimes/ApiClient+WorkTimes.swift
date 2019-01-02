//
//  ApiClient+WorkTimes.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientWorkTimesType: class {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder]>) -> Void))
}

extension ApiClient: ApiClientWorkTimesType {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder]>) -> Void)) {
        get(.worktimes, parameters: parameters, completion: completion)
    }
}
