//
//  KeychainAccessMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class KeychainAccessMock {
    var getReturnValue: String?
    var getThrowError: Error?
    private(set) var getParams: [GetParams] = []
    struct GetParams {
        var key: String
    }
    
    var getDataReturnValue: Data?
    var getDataThrowError: Error?
    private(set) var getDataParams: [GetDataParams] = []
    struct GetDataParams {
        var key: String
    }
    
    var setThrowError: Error?
    private(set) var setParams: [SetParams] = []
    struct SetParams {
        var value: String
        var key: String
    }
    
    var setDataThrowError: Error?
    private(set) var setDataParams: [SetDataParams] = []
    struct SetDataParams {
        var value: Data
        var key: String
    }
}

// MARK: - KeychainAccessType
extension KeychainAccessMock: KeychainAccessType {
    func get(_ key: String) throws -> String? {
        self.getParams.append(GetParams(key: key))
        if let error = self.getThrowError {
            throw error
        }
        return self.getReturnValue
    }
    
    func getData(_ key: String) throws -> Data? {
        self.getDataParams.append(GetDataParams(key: key))
        if let error = self.getDataThrowError {
            throw error
        }
        return self.getDataReturnValue
    }
    
    func set(_ value: String, key: String) throws {
        self.setParams.append(SetParams(value: value, key: key))
        if let error = self.setThrowError {
            throw error
        }
    }
    
    func set(_ value: Data, key: String) throws {
        self.setDataParams.append(SetDataParams(value: value, key: key))
        if let error = self.setDataThrowError {
            throw error
        }
    }
}
