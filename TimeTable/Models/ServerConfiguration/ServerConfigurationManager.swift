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
    #if TEST
    func set(configuration: ServerConfiguration)
    #endif
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
    }
}

// MARK: - ServerConfigurationManagerType
extension ServerConfigurationManager: ServerConfigurationManagerType {
    func getOldConfiguration() -> ServerConfiguration? {
        guard let hostURLString = self.userDefaults.string(forKey: UserDefaultsKeys.hostURLKey) else { return nil }
        guard let hostURL = URL(string: hostURLString) else { return nil }
        return ServerConfiguration(host: hostURL)
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
    
    #if TEST
    func set(configuration: ServerConfiguration) {
        self.save(configuration: configuration)
    }
    #endif
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
        guard let hostURL = configuration.host else { return }
        self.userDefaults.set(hostURL.absoluteString, forKey: UserDefaultsKeys.hostURLKey)
    }
}
