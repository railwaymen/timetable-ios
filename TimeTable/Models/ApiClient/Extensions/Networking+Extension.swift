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
    func post(_ path: String, parameters: Any?, completion: @escaping (_ result: Result<Data>) -> Void) -> String
}

extension Networking: NetworkingType {
    func post(_ path: String, parameters: Any?, completion: @escaping (Result<Data>) -> Void) -> String {
        return post(path, parameterType: .json, parameters: parameters, completion: { result in
            switch result {
            case .success(let successResponse):
                completion(.success(successResponse.data))
            case .failure(let failureResponse):
                completion(.failure(failureResponse.error))
            }
        })
    }
}
