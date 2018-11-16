//
//  AccessService.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import KeychainAccess

protocol AccessServiceLoginCredentialsType: class {
    func saveUser(credentails: LoginCredentials) throws
    func getUserCredentials() throws -> LoginCredentials
}

class AccessService {
    private var userDefaults: UserDefaultsType
    private var keychainAccess: KeychainAccessType
    private var encoder: JSONEncoderType
    private var decoder: JSONDecoderType
    
    enum Error: Swift.Error {
        case cannotSaveLoginCredentials
        case cannotFetchLoginCredentials
    }
    
    private struct Keys {
        static let loginCredentialsKey = "key.time_table.login_credentials.key"
    }
    
    init(userDefaults: UserDefaultsType, keychainAccess: KeychainAccessType,
         buildEncoder: (() -> JSONEncoderType), buildDecoder: (() -> JSONDecoderType)) {
        self.userDefaults = userDefaults
        self.keychainAccess = keychainAccess
        self.encoder = buildEncoder()
        self.decoder = buildDecoder()
    }
}

// MARK: - AccessServiceLoginCredentialsType
extension AccessService: AccessServiceLoginCredentialsType {
    func saveUser(credentails: LoginCredentials) throws {
        do {
            let data = try encoder.encode(credentails)
            try keychainAccess.set(data, key: Keys.loginCredentialsKey)
        } catch {
            throw Error.cannotSaveLoginCredentials
        }
    }
    
    func getUserCredentials() throws -> LoginCredentials {
        do {
            guard let data = try keychainAccess.getData(Keys.loginCredentialsKey) else { throw Error.cannotFetchLoginCredentials }
            return try decoder.decode(LoginCredentials.self, from: data)
        } catch {
            throw Error.cannotFetchLoginCredentials
        }
    }
}
