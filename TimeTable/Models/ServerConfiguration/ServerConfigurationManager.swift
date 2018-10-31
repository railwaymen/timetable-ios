//
//  ServerConfigurationManager.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ServerConfigurationManagerType: class {
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void))
}

class ServerConfigurationManager: ServerConfigurationManagerType {
    
    private var urlSession: URLSessionType
    
    // MARK: - Initialization
    init(urlSession: URLSessionType) {
        self.urlSession = urlSession
    }
    
    // MARK: - ServerConfigurationManagerType
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void)) {
        var request = URLRequest(url: configuration.host)
        request.httpMethod = HTTPMethods.HEAD.rawValue
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, error == nil, response.statusCode == 200 {
                completion(.success(Void()))
            } else {
                completion(.failure(ApiError.invalidHost(configuration.host)))
            }
        }
        dataTask.resume()
    }
}
