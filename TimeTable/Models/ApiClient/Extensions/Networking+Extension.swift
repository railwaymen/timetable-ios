//
//  Networking+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Networking

protocol NetworkingType: class {
    var headerFields: [String: String]? { get set }
    func post(_ path: String, parameters: Any?, completion: @escaping (Result<Data>) -> Void)
    func get(_ path: String, parameters: Any?, cachingLevel: Networking.CachingLevel, completion: @escaping (Result<Data>) -> Void)
}

extension Networking: NetworkingType {
    func post(_ path: String, parameters: Any?, completion: @escaping (Result<Data>) -> Void) {
        _ = post(path, parameterType: .json, parameters: parameters, completion: { result in
            self.handleResponse(result: result, completion: completion)
        })
    }
 
    func get(_ path: String, parameters: Any?, cachingLevel: CachingLevel, completion: @escaping (Result<Data>) -> Void) {
        _ = get(path, parameters: parameters, cachingLevel: cachingLevel, completion: { (result: JSONResult) in
            self.handleResponse(result: result, completion: completion)
        })
    }
    
    // MARK: - Private
    private func handleResponse(result: JSONResult, completion: (Result<Data>) -> Void) {
        switch result {
        case .success(let successResponse):
            completion(.success(successResponse.data))
        case .failure(let failureResponse):
            completion(.failure(failureResponse.error))
        }
    }
}
