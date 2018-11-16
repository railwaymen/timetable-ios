//
//  KeyChainType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 16/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import KeychainAccess

protocol KeychainAccessType: class {
    func get(_ key: String) throws -> String?
    func getData(_ key: String) throws -> Data?
    func set(_ value: String, key: String) throws
    func set(_ value: Data, key: String) throws
}

extension Keychain: KeychainAccessType {}
