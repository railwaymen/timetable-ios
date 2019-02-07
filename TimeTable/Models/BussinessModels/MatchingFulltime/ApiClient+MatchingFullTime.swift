//
//  ApiClient+MatchingFullTime.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientMatchingFullTimeType: class {
    func fetchMatchingFullTime(parameters: MatchingFullTimeEncoder, completion: @escaping ((Result<MatchingFullTimeDecoder>) -> Void))
}

// MARK: - ApiClientSessionType
extension ApiClient: ApiClientMatchingFullTimeType {
    func fetchMatchingFullTime(parameters: MatchingFullTimeEncoder, completion: @escaping ((Result<MatchingFullTimeDecoder>) -> Void)) {
        get(.matchingFullTime, parameters: parameters, completion: completion)
    }
}
