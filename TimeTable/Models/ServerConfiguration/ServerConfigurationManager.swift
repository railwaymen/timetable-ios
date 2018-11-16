//
//  ServerConfigurationManager.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ServerConfigurationManagerType: class {
    func getOldConfiguration() -> ServerConfiguration?
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void))
}

class ServerConfigurationManager: ServerConfigurationManagerType {
    
    private var urlSession: URLSessionType
    private var userDefaults: UserDefaultsType
    
    private struct UserDefaultsKeys {
        static let hostURLKey = "key.time_table.server_configuration.host"
        static let shouldRemeberHostKey = "key.time_table.server_configuration.should_remeber_host_key"
    }
    
    // MARK: - Initialization
    init(urlSession: URLSessionType, userDefaults: UserDefaultsType) {
        self.urlSession = urlSession
        self.userDefaults = userDefaults
    }
    
    // MARK: - ServerConfigurationManagerType
    func getOldConfiguration() -> ServerConfiguration? {
        let shouldRememberHost = userDefaults.bool(forKey: UserDefaultsKeys.shouldRemeberHostKey)
        var configuration = ServerConfiguration(host: nil, shouldRememberHost: shouldRememberHost)
        if shouldRememberHost {
            guard let hostURLString = userDefaults.string(forKey: UserDefaultsKeys.hostURLKey) else { return nil }
            guard let hostURL = URL(string: hostURLString) else { return nil }
            configuration.host = hostURL
        }
        return configuration
    }
    
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void>) -> Void)) {
        guard let hostURL = configuration.host else {
            completion(.failure(ApiError.invalidHost(configuration.host)))
            return
        }
        var request = URLRequest(url: hostURL)
        request.httpMethod = HTTPMethods.HEAD.rawValue
        let dataTask = urlSession.dataTask(with: request) { [weak self] (_, response, error) in
            if let response = response as? HTTPURLResponse, error == nil, response.statusCode == 200 {
                self?.save(configuration: configuration)
                completion(.success(Void()))
            } else {
                completion(.failure(ApiError.invalidHost(hostURL)))
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Pirvate
    private func save(configuration: ServerConfiguration) {
        if configuration.shouldRememberHost, let hostURL = configuration.host {
            userDefaults.set(hostURL.absoluteString, forKey: UserDefaultsKeys.hostURLKey)
        }
        userDefaults.set(configuration.shouldRememberHost, forKey: UserDefaultsKeys.shouldRemeberHostKey)
    }
}
