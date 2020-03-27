//
//  ServerConfigurationManager.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Restler

protocol ServerConfigurationManagerType: class {
    func getOldConfiguration() -> ServerConfiguration?
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void, Error>) -> Void))
}

class ServerConfigurationManager {
    private var urlSession: URLSessionType
    private var userDefaults: UserDefaultsType
    private let dispatchQueueManager: DispatchQueueManagerType
    
    // MARK: - Initialization
    init(
        urlSession: URLSessionType,
        userDefaults: UserDefaultsType,
        dispatchQueueManager: DispatchQueueManagerType
    ) {
        self.urlSession = urlSession
        self.userDefaults = userDefaults
        self.dispatchQueueManager = dispatchQueueManager
    }
}

// MARK: - Structures
extension ServerConfigurationManager {
    private struct UserDefaultsKeys {
        static let hostURLKey = "key.time_table.server_configuration.host"
        static let shouldRemeberHostKey = "key.time_table.server_configuration.should_remeber_host_key"
    }
}

// MARK: - ServerConfigurationManagerType
extension ServerConfigurationManager: ServerConfigurationManagerType {
    func getOldConfiguration() -> ServerConfiguration? {
        let shouldRememberHost = self.userDefaults.bool(forKey: UserDefaultsKeys.shouldRemeberHostKey)
        var configuration = ServerConfiguration(host: nil, shouldRememberHost: shouldRememberHost)
        if shouldRememberHost {
            guard let hostURLString = self.userDefaults.string(forKey: UserDefaultsKeys.hostURLKey) else { return nil }
            guard let hostURL = URL(string: hostURLString) else { return nil }
            configuration.host = hostURL
        }
        return configuration
    }
    
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void, Error>) -> Void)) {
        let mainThreadCompletion: ((Result<Void, Error>) -> Void) = { [dispatchQueueManager] result in
            dispatchQueueManager.performOnMainThread(taskType: .async) {
                completion(result)
            }
        }
        guard let hostURL = configuration.host else {
            mainThreadCompletion(.failure(ApiClientError(type: .invalidHost(configuration.host))))
            return
        }
        var request = URLRequest(url: hostURL)
        request.httpMethod = HTTPMethods.HEAD.rawValue
        let dataTask = self.urlSession.dataTask(with: request) { [weak self] (_, response, error) in
            if let response = response as? HTTPURLResponse, error == nil, response.statusCode == 200 {
                self?.save(configuration: configuration)
                mainThreadCompletion(.success(Void()))
            } else if let apiClientError = ApiClientError(response: Restler.Response(data: nil, response: response as? HTTPURLResponse, error: error)) {
                mainThreadCompletion(.failure(apiClientError))
            } else {
                mainThreadCompletion(.failure(ApiClientError(type: .invalidHost(hostURL))))
            }
        }
        dataTask.resume()
    }
}
 
// MARK: - Private
extension ServerConfigurationManager {
    private func save(configuration: ServerConfiguration) {
        if configuration.shouldRememberHost, let hostURL = configuration.host {
            self.userDefaults.set(hostURL.absoluteString, forKey: UserDefaultsKeys.hostURLKey)
        }
        self.userDefaults.set(configuration.shouldRememberHost, forKey: UserDefaultsKeys.shouldRemeberHostKey)
    }
}
