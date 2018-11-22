//
//  KeychainAccessMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
class KeychainAccessMock: KeychainAccessType {
    private(set) var getStringValues: (called: Bool, key: String?) = (false, nil)
    var getStringIsThrowingError = false
    var getStringValue: String?
    func get(_ key: String) throws -> String? {
        getStringValues = (true, key)
        if getStringIsThrowingError {
            throw TestError(messsage: "set Data error")
        } else {
            return getStringValue
        }
    }

    private(set) var getDataValues: (called: Bool, key: String?) = (false, nil)
    var getDataIsThrowingError = false
    var getDataValue: Data?
    func getData(_ key: String) throws -> Data? {
        getDataValues = (true, key)
        if getDataIsThrowingError {
            throw TestError(messsage: "set Data error")
        } else {
            return getDataValue
        }
    }
    
    private(set) var setStringValues: (called: Bool, value: String?, key: String?) = (false, nil, nil)
    var setStringIsThrowingError = false
    func set(_ value: String, key: String) throws {
        setStringValues = (true, value, key)
        if setStringIsThrowingError {
            throw TestError(messsage: "set String error")
        }
    }
    
    private(set) var setDataValues: (called: Bool, value: Data?, key: String?) = (false, nil, nil)
    var setDataIsThrowingError = false
    func set(_ value: Data, key: String) throws {
        setDataValues = (true, value, key)
        if setDataIsThrowingError {
            throw TestError(messsage: "set Data error")
        }
    }
}
// swiftlint:enable large_tuple
