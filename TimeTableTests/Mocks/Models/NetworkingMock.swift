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

class NetworkingMock {
    var headerFields: [String: String]?
    
    private(set) var postParams: [PostParams] = []
    struct PostParams {
        var path: String
        var parameters: Any?
        var completion: (Swift.Result<Data, Error>) -> Void
    }
    
    private(set) var getParams: [GetParams] = []
    struct GetParams {
        var path: String
        var parameters: Any?
        var cachingLevel: Networking.CachingLevel
        var completion: (Swift.Result<Data, Error>) -> Void
    }
    
    private(set) var deleteParams: [DeleteParams] = []
    struct DeleteParams {
        var path: String
        var completion: ((Swift.Result<Void, Error>) -> Void)
    }
    
    private(set) var putParams: [PutParams] = []
    struct PutParams {
        var path: String
        var parameters: Any?
        var completion: (Swift.Result<Data, Error>) -> Void
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    func post(_ path: String, parameters: Any?, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        self.postParams.append(PostParams(path: path, parameters: parameters, completion: completion))
    }
    
    func get(_ path: String, parameters: Any?, cachingLevel: Networking.CachingLevel, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        self.getParams.append(GetParams(path: path, parameters: parameters, cachingLevel: cachingLevel, completion: completion))
    }
    
    func delete(_ path: String, completion: @escaping ((Swift.Result<Void, Error>) -> Void)) {
        self.deleteParams.append(DeleteParams(path: path, completion: completion))
    }
    
    func put(_ path: String, parameters: Any?, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        self.putParams.append(PutParams(path: path, parameters: parameters, completion: completion))
    }
}
