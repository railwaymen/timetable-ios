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
        self.getStringValues = (true, key)
        if self.getStringIsThrowingError {
            throw TestError(message: "set Data error")
        } else {
            return self.getStringValue
        }
    }

    private(set) var getDataValues: (called: Bool, key: String?) = (false, nil)
    var getDataIsThrowingError = false
    var getDataValue: Data?
    func getData(_ key: String) throws -> Data? {
        self.getDataValues = (true, key)
        if self.getDataIsThrowingError {
            throw TestError(message: "set Data error")
        } else {
            return self.getDataValue
        }
    }
    
    private(set) var setStringValues: (called: Bool, value: String?, key: String?) = (false, nil, nil)
    var setStringIsThrowingError = false
    func set(_ value: String, key: String) throws {
        self.setStringValues = (true, value, key)
        if self.setStringIsThrowingError {
            throw TestError(message: "set String error")
        }
    }
    
    private(set) var setDataValues: (called: Bool, value: Data?, key: String?) = (false, nil, nil)
    var setDataIsThrowingError = false
    func set(_ value: Data, key: String) throws {
        self.setDataValues = (true, value, key)
        if self.setDataIsThrowingError {
            throw TestError(message: "set Data error")
        }
    }
}
// swiftlint:enable large_tuple
