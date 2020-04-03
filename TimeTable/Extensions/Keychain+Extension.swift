//
//  Keychain+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import KeychainAccess

protocol KeychainAccessType: class {
    func get(_ key: String, ignoringAttributeSynchronizable: Bool) throws -> String?
    func getData(_ key: String, ignoringAttributeSynchronizable: Bool) throws -> Data?
    func set(_ value: String, key: String, ignoringAttributeSynchronizable: Bool) throws
    func set(_ value: Data, key: String, ignoringAttributeSynchronizable: Bool) throws
    func remove(_ key: String, ignoringAttributeSynchronizable: Bool) throws
}

extension KeychainAccessType {
    func get(_ key: String) throws -> String? {
        return try self.get(key, ignoringAttributeSynchronizable: true)
    }
    
    func getData(_ key: String) throws -> Data? {
        return try self.getData(key, ignoringAttributeSynchronizable: true)
    }
    
    func set(_ value: String, key: String) throws {
        try self.set(value, key: key, ignoringAttributeSynchronizable: true)
    }
    
    func set(_ value: Data, key: String) throws {
        try self.set(value, key: key, ignoringAttributeSynchronizable: true)
    }
    
    func remove(_ key: String) throws {
        try self.remove(key, ignoringAttributeSynchronizable: true)
    }
}

extension Keychain: KeychainAccessType {}
