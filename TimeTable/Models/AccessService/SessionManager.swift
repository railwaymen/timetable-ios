//
//  SessionManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 02/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

typealias SessionManagerable = SessionManagerType & UserDataManagerType

protocol SessionManagerType: class {
    func open(session: SessionDecoder)
    func closeSession()
    func getSession() -> SessionDecoder?
}

class SessionManager {
    private let keychainBuilder: KeychainBuilderType
    private let encoder: JSONEncoderType
    private let decoder: JSONDecoderType
    private let errorHandler: ErrorHandlerType
    private let serverConfigurationManager: ServerConfigurationManagerType
    
    private var keychainAccess: KeychainAccessType {
        let url = self.serverConfigurationManager.getOldConfiguration()?.host
        return self.keychainBuilder.build(forURL: url)
    }
    
    private var isSessionOpened: Bool {
        self.readSessionDecoderFromKeychain() != nil
    }
    
    // MARK: - Initialization
    init(
        keychainBuilder: KeychainBuilderType,
        encoder: JSONEncoderType,
        decoder: JSONDecoderType,
        errorHandler: ErrorHandlerType,
        serverConfigurationManager: ServerConfigurationManagerType
    ) {
        self.keychainBuilder = keychainBuilder
        self.encoder = encoder
        self.decoder = decoder
        self.errorHandler = errorHandler
        self.serverConfigurationManager = serverConfigurationManager
    }
}

// MARK: - Structures
extension SessionManager {
    enum KeychainError: Error {
        case keychainDoesNotExist
    }
    
    private struct Key {
        static let userSession = "key.time_table.user_session"
        static let userData = "key.time_table.user_data"
    }
}

// MARK: - SessionManagerType
extension SessionManager: SessionManagerType {
    func open(session: SessionDecoder) {
        do {
            let data = try self.encoder.encode(session)
            try self.keychainAccess.set(data, key: Key.userSession)
        } catch {
            self.errorHandler.stopInDebug("\(error)")
        }
    }
    
    func closeSession() {
        guard self.isSessionOpened else { return }
        do {
            try self.keychainAccess.remove(Key.userData)
            try self.keychainAccess.remove(Key.userSession)
        } catch {
            self.errorHandler.stopInDebug("\(error)")
        }
    }
    
    func getSession() -> SessionDecoder? {
        return self.readSessionDecoderFromKeychain()
    }
}

// MARK: - UserDataManagerType
extension SessionManager: UserDataManagerType {
    func setUserData(_ user: UserDecoder) {
        do {
            let data = try self.encoder.encode(user)
            try self.keychainAccess.set(data, key: Key.userData)
        } catch {
            self.errorHandler.stopInDebug("\(error)")
        }
    }
    
    func getUserData() -> UserDecoder? {
        guard let data = try? self.keychainAccess.getData(Key.userData) else { return nil }
        return try? self.decoder.decode(UserDecoder.self, from: data)
    }
}

// MARK: - Private
extension SessionManager {
    private func readSessionDecoderFromKeychain() -> SessionDecoder? {
        guard let data = try? self.keychainAccess.getData(Key.userSession) else { return nil }
        return try? self.decoder.decode(SessionDecoder.self, from: data)
    }
}
