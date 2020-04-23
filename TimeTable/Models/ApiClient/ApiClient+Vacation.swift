//
//  ApiClient+Vacation.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias VacationResult = Result<VacationResponse, Error>
typealias VacationCompletion = (VacationResult) -> Void

protocol ApiClientVacationType: class {
    func fetchVacation(paramters: VacationParameters, completion: @escaping VacationCompletion) -> RestlerTaskType?
}

extension ApiClient: ApiClientVacationType {
    func fetchVacation(paramters: VacationParameters, completion: @escaping VacationCompletion) -> RestlerTaskType? {
        return self.restler
            .get(Endpoint.vacation)
            .query(paramters)
            .decode(VacationResponse.self)
            .onCompletion(completion)
            .start()
    }
}
