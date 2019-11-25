//
//  AccessService.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

typealias AccessServiceLoginType = (AccessServiceLoginCredentialsType & AccessServiceUserIDType & AccessServiceSessionType)

protocol AccessServiceLoginCredentialsType: class {
    func saveUser(credentails: LoginCredentials) throws
    func getUserCredentials() throws -> LoginCredentials
    func removeLastLoggedInUserIdentifier()
}

protocol AccessServiceUserIDType: class {
    func saveLastLoggedInUserIdentifier(_ identifer: Int64)
    func getLastLoggedInUserIdentifier() -> Int64?
}

protocol AccessServiceSessionType: class {
    func getSession(completion: @escaping ((Result<SessionDecoder, Error>) -> Void))
}

class AccessService {
    private let userDefaults: UserDefaultsType
    private let keychainAccess: KeychainAccessType
    private let coreData: CoreDataStackUserType
    private let encoder: JSONEncoderType
    private let decoder: JSONDecoderType
    
    // MARK: - Initialization
    init(
        userDefaults: UserDefaultsType,
        keychainAccess: KeychainAccessType,
        coreData: CoreDataStackUserType,
        encoder: JSONEncoderType,
        decoder: JSONDecoderType
    ) {
        self.userDefaults = userDefaults
        self.keychainAccess = keychainAccess
        self.coreData = coreData
        self.encoder = encoder
        self.decoder = decoder
    }
}

// MARK: - Structures
extension AccessService {
    enum Error: Swift.Error {
        case userNeverLoggedIn
        case cannotSaveLoginCredentials
        case cannotFetchLoginCredentials
    }
    
    private struct Keys {
        static let loginCredentialsKey = "key.time_table.login_credentials.key"
        static let lastLoggedInUserIdentifier = "key.time_table.last_logged_user.id.key"
    }
}

// MARK: - AccessServiceLoginCredentialsType
extension AccessService: AccessServiceLoginCredentialsType {
    func saveUser(credentails: LoginCredentials) throws {
        do {
            let data = try self.encoder.encode(credentails)
            try self.keychainAccess.set(data, key: Keys.loginCredentialsKey)
        } catch {
            throw Error.cannotSaveLoginCredentials
        }
    }
    
    func getUserCredentials() throws -> LoginCredentials {
        guard let data = try self.keychainAccess.getData(Keys.loginCredentialsKey) else { throw Error.cannotFetchLoginCredentials }
        return try self.decoder.decode(LoginCredentials.self, from: data)
    }
}

// MARK: - AccessServiceUserIDType
extension AccessService: AccessServiceUserIDType {
    func saveLastLoggedInUserIdentifier(_ identifer: Int64) {
        self.userDefaults.set(identifer, forKey: Keys.lastLoggedInUserIdentifier)
    }
    
    func getLastLoggedInUserIdentifier() -> Int64? {
        guard let identifier = self.userDefaults.object(forKey: Keys.lastLoggedInUserIdentifier) as? Int64 else { return nil }
        return identifier
    }
    
    func removeLastLoggedInUserIdentifier() {
        self.userDefaults.removeObject(forKey: Keys.lastLoggedInUserIdentifier)
    }
}

// MARK: - AccessServiceSessionType
extension AccessService: AccessServiceSessionType {
    func getSession(completion: @escaping ((Result<SessionDecoder, Swift.Error>) -> Void)) {
        guard let identifier = self.getLastLoggedInUserIdentifier() else {
            return completion(.failure(Error.userNeverLoggedIn))
        }
        self.coreData.fetchUser(forIdentifier: identifier) { result in
            switch result {
            case .success(let entity):
                completion(.success(SessionDecoder(entity: entity)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
