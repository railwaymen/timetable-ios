//
//  ApiClient+AccountingPeriods.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientAccountingPeriodsType: class {
    func fetchAccountingPeriods(
        parameters: AccountingPeriodsParameters,
        completion: @escaping (Result<AccountingPeriodsResponse, Error>) -> Void)
    func fetchMatchingFullTime(
        parameters: MatchingFullTimeEncoder,
        completion: @escaping ((Result<MatchingFullTimeDecoder, Error>) -> Void))
}

extension ApiClient: ApiClientAccountingPeriodsType {
    func fetchAccountingPeriods(
        parameters: AccountingPeriodsParameters,
        completion: @escaping (Result<AccountingPeriodsResponse, Error>) -> Void
    ) {
        _ = self.restler
            .get(Endpoint.accountingPeriods)
            .query(parameters)
            .decode(AccountingPeriodsResponse.self)
            .onCompletion(completion)
            .start()
    }
    
    func fetchMatchingFullTime(
        parameters: MatchingFullTimeEncoder,
        completion: @escaping ((Result<MatchingFullTimeDecoder, Error>) -> Void)
    ) {
        _ = self.restler
            .get(Endpoint.matchingFullTime)
            .query(parameters)
            .decode(MatchingFullTimeDecoder.self)
            .onCompletion(completion)
            .start()
    }
}
