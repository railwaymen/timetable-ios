//
//  ApiClient+Vacation.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias FetchVacationResult = Result<VacationResponse, Error>
typealias FetchVacationCompletion = (FetchVacationResult) -> Void

typealias AddVacationResult = Result<VacationDecoder, Error>
typealias AddVacationCompletion = (AddVacationResult) -> Void

protocol ApiClientVacationType: class {
    func fetchVacation(parameters: VacationParameters, completion: @escaping FetchVacationCompletion) -> RestlerTaskType?
    func addVacation(vacation: VacationEncoder, completion: @escaping AddVacationCompletion) -> RestlerTaskType?
}

extension ApiClient: ApiClientVacationType {
    func fetchVacation(parameters: VacationParameters, completion: @escaping FetchVacationCompletion) -> RestlerTaskType? {
        return self.restler
            .get(Endpoint.vacation)
            .query(parameters)
            .decode(VacationResponse.self)
            .onCompletion(completion)
            .start()
    }
    
    func addVacation(vacation: VacationEncoder, completion: @escaping AddVacationCompletion) -> RestlerTaskType? {
        return self.restler
            .post(Endpoint.vacation)
            .body(vacation)
            .decode(VacationDecoder.self)
            .onCompletion(completion)
            .start()
        
    }
}
