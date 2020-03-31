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
    func verify(configuration: ServerConfiguration, completion: @escaping ((Result<Void, Error>) -> Void))
}

class ServerConfigurationManager {
    private var userDefaults: UserDefaultsType
    private let dispatchQueueManager: DispatchQueueManagerType
    private let restlerFactory: RestlerFactoryType
    
    // MARK: - Initialization
    init(
        userDefaults: UserDefaultsType,
        dispatchQueueManager: DispatchQueueManagerType,
        restlerFactory: RestlerFactoryType
    ) {
        self.userDefaults = userDefaults
        self.dispatchQueueManager = dispatchQueueManager
        self.restlerFactory = restlerFactory
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
        let mainThreadCompletion = self.mainThreadClosure(completion)
        let defaultError = ApiClientError(type: .invalidHost(configuration.host))
        guard let hostURL = configuration.host else {
            mainThreadCompletion(.failure(defaultError))
            return
        }
        let restler = self.restlerFactory.buildRestler(withBaseURL: hostURL)
        _ = restler
            .head("")
            .failureDecode(ApiClientError.self)
            .decode(Void.self)
            .onSuccess({ [weak self] in
                self?.save(configuration: configuration)
                mainThreadCompletion(.success(Void()))
            })
            .onFailure({ error in
                let apiClientError = (error as? ApiClientError) ?? defaultError
                mainThreadCompletion(.failure(apiClientError))
            })
            .start()
    }
}
 
// MARK: - Private
extension ServerConfigurationManager {
    private func mainThreadClosure<T>(_ closure: @escaping (T) -> Void) -> ((T) -> Void) {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.performOnMainThread(taskType: .async) {
                closure(result)
            }
        }
    }
    
    private func save(configuration: ServerConfiguration) {
        if configuration.shouldRememberHost, let hostURL = configuration.host {
            self.userDefaults.set(hostURL.absoluteString, forKey: UserDefaultsKeys.hostURLKey)
        }
        self.userDefaults.set(configuration.shouldRememberHost, forKey: UserDefaultsKeys.shouldRemeberHostKey)
    }
}
