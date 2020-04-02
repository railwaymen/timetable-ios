//
//  SessionManager.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 02/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol SessionManagerType: class {
    var isSessionOpened: Bool { get }
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
    }
}

// MARK: - SessionManagerType
extension SessionManager: SessionManagerType {
    var isSessionOpened: Bool {
        self.getSession() != nil
    }
    
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
            try self.keychainAccess.remove(Key.userSession)
        } catch {
            self.errorHandler.stopInDebug("\(error)")
        }
    }
    
    func getSession() -> SessionDecoder? {
        do {
            guard let data = try self.keychainAccess.getData(Key.userSession) else { return nil }
            return try self.decoder.decode(SessionDecoder.self, from: data)
        } catch {
            self.errorHandler.stopInDebug("\(error)")
            return nil
        }
    }
}
