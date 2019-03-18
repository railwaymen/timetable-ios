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
    var headerFields: [String: String]?

    private(set) var shortPostValues: (path: String, parametres: Any?)?
    private(set) var shortPostCompletion: ((TimeTable.Result<Data>) -> Void)?
    func post(_ path: String, parameters: Any?, completion: @escaping (TimeTable.Result<Data>) -> Void) {
        shortPostValues = (path, parameters)
        shortPostCompletion = completion
    }
    
    private(set) var getValues: (path: String, parameters: Any?, cachingLevel: Networking.CachingLevel)?
    private(set) var getCompletion: ((TimeTable.Result<Data>) -> Void)?
    func get(_ path: String, parameters: Any?, cachingLevel: Networking.CachingLevel, completion: @escaping (TimeTable.Result<Data>) -> Void) {
        getValues = (path, parameters, cachingLevel)
        getCompletion = completion
    }
    
    private(set) var deletePath: String?
    private(set) var deleteCompletion: ((TimeTable.Result<Void>) -> Void)?
    func delete(_ path: String, completion: @escaping ((TimeTable.Result<Void>) -> Void)) {
        deletePath = path
        deleteCompletion = completion
    }
}
// swiftlint:enable large_tuple
