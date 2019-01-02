//
//  NetworkingMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Networking
@testable import TimeTable

// swiftlint:disable large_tuple
class NetworkingMock: NetworkingType {
    private(set) var shortPostValues: (path: String, parametres: Any?)?
    private(set) var shortPostCompletion: ((TimeTable.Result<Data>) -> Void)?
    
    private(set) var getValues: (path: String, parameters: Any?, cachingLevel: Networking.CachingLevel)?
    private(set) var getCompletion: ((TimeTable.Result<Data>) -> Void)?
    
    var headerFields: [String: String]?
    
    func post(_ path: String, parameters: Any?, completion: @escaping (TimeTable.Result<Data>) -> Void) {
        shortPostValues = (path, parameters)
        shortPostCompletion = completion
    }
    
    func get(_ path: String, parameters: Any?, cachingLevel: Networking.CachingLevel, completion: @escaping (TimeTable.Result<Data>) -> Void) {
        getValues = (path, parameters, cachingLevel)
        getCompletion = completion
    }
}
// swiftlint:enable large_tuple
