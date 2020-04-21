//
//  KeychainBuilder.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 02/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import KeychainAccess

protocol KeychainBuilderType: class {
    func build(forURL url: URL?) -> KeychainAccessType
}

class KeychainBuilder: KeychainBuilderType {
    func build(forURL url: URL?) -> KeychainAccessType {
        if let host = url {
            if host.isHTTP {
                return Keychain(server: host, protocolType: .http)
            } else if host.isHTTPS {
                return Keychain(server: host, protocolType: .https)
            }
        }
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return Keychain()
        }
        return Keychain(accessGroup: bundleID)
    }
}
