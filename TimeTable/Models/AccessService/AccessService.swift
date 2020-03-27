//
//  AccessService.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

typealias AccessServiceLoginType = (AccessServiceUserIDType & AccessServiceSessionType)

protocol AccessServiceUserIDType: class {
    func getLastLoggedInUserIdentifier() -> Int64?
}

protocol AccessServiceSessionType: class {
    func getSession() throws -> SessionDecoder
    func saveSession(_ session: SessionDecoder) throws
    func removeSession() throws
}

class AccessService {
    private let keychainAccess: KeychainAccessType
    private let encoder: JSONEncoderType
    private let decoder: JSONDecoderType
    
    // MARK: - Initialization
    init(
        keychainAccess: KeychainAccessType,
        encoder: JSONEncoderType,
        decoder: JSONDecoderType
    ) {
        self.keychainAccess = keychainAccess
        self.encoder = encoder
        self.decoder = decoder
    }
}

// MARK: - Structures
extension AccessService {
    enum Error: Swift.Error {
        case userNeverLoggedIn
    }
    
    private struct Key {
        static let userSession = "key.time_table.user_session"
    }
}

// MARK: - AccessServiceUserIDType
extension AccessService: AccessServiceUserIDType {
    func getLastLoggedInUserIdentifier() -> Int64? {
        do {
            let session = try self.getSession()
            return Int64(session.identifier)
        } catch {
            return nil
        }
    }
}

// MARK: - AccessServiceSessionType
extension AccessService: AccessServiceSessionType {
    func getSession() throws -> SessionDecoder {
        guard let data = try self.keychainAccess.getData(Key.userSession) else { throw Error.userNeverLoggedIn }
        return try self.decoder.decode(SessionDecoder.self, from: data)
    }
    
    func saveSession(_ session: SessionDecoder) throws {
        let data = try self.encoder.encode(session)
        try self.keychainAccess.set(data, key: Key.userSession)
    }
    
    func removeSession() throws {
        try self.keychainAccess.remove(Key.userSession)
    }
}
