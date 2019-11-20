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
    func post(_ path: String, parameters: Any?, completion: @escaping (Swift.Result<Data, Error>) -> Void)
    func get(_ path: String, parameters: Any?, cachingLevel: Networking.CachingLevel, completion: @escaping (Swift.Result<Data, Error>) -> Void)
    func delete(_ path: String, completion: @escaping ((Swift.Result<Void, Error>) -> Void))
    func put(_ path: String, parameters: Any?, completion: @escaping (Swift.Result<Data, Error>) -> Void)
}

extension Networking: NetworkingType {
    func post(_ path: String, parameters: Any?, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        _ = self.post(path, parameterType: .json, parameters: parameters, completion: { [weak self] result in
            self?.handleResponse(result: result, completion: completion)
        })
    }
 
    func get(_ path: String, parameters: Any?, cachingLevel: CachingLevel, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        _ = self.get(path, parameters: parameters, cachingLevel: cachingLevel, completion: { [weak self] result in
            self?.handleResponse(result: result, completion: completion)
        })
    }
    
    func delete(_ path: String, completion: @escaping ((Swift.Result<Void, Error>) -> Void)) {
        _ = self.delete(path, completion: { [weak self] result in
            self?.handleResponse(result: result, completion: completion)
        })
    }
    
    func put(_ path: String, parameters: Any?, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        _ = self.put(path, parameterType: .json, parameters: parameters, completion: { [weak self] result in
            self?.handleResponse(result: result, completion: completion)
        })
    }
}

// MARK: - Private
extension Networking {
    private func handleResponse(result: JSONResult, completion: (Swift.Result<Data, Error>) -> Void) {
        switch result {
        case .success(let successResponse):
            completion(.success(successResponse.data))
        case .failure(let failureResponse):
            let error = handle(failureResponse: failureResponse)
            completion(.failure(error))
        }
    }
    
    private func handleResponse(result: JSONResult, completion: (Swift.Result<Void, Error>) -> Void) {
        switch result {
        case .success:
            completion(.success(Void()))
        case .failure(let failureResponse):
            let error = handle(failureResponse: failureResponse)
            completion(.failure(error))
        }
    }
    
    private func handle(failureResponse: FailureJSONResponse) -> Error {
        return ApiClientError(data: failureResponse.data)
            ?? ApiClientError(code: failureResponse.error.code)
            ?? failureResponse.error as Error
    }
}
