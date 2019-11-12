//
//  UserDefaultsMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

// swiftlint:disable large_tuple
class UserDefaultsMock: UserDefaultsType {
    
    var setAnyValueDictionary: [String: Any?] = [:]
    var setBoolValueDictionary: [String: Bool] = [:]
    
    private(set) var boolForKeyValues: (called: Bool, defaultName: String?) = (false, nil)
    func bool(forKey defaultName: String) -> Bool {
        self.boolForKeyValues = (true, defaultName)
        return self.setBoolValueDictionary[defaultName] ?? false
    }
    
    private(set) var removeObjectValues: (called: Bool, defaultName: String?) = (false, nil)
    func removeObject(forKey defaultName: String) {
        self.setAnyValueDictionary.removeValue(forKey: defaultName)
        self.setBoolValueDictionary.removeValue(forKey: defaultName)
        self.removeObjectValues = (true, defaultName)
    }
    
    private(set) var setAnyValues: (called: Bool, value: Any?, defaultName: String?) = (false, nil, nil)
    func set(_ value: Any?, forKey defaultName: String) {
        self.setAnyValueDictionary[defaultName] = value
        self.setAnyValues = (true, value, defaultName)
    }
    
    private(set) var setBoolValues: (called: Bool, defaultName: String?) = (false, nil)
    func set(_ value: Bool, forKey defaultName: String) {
        self.setBoolValueDictionary[defaultName] = value
        self.setBoolValues = (true, defaultName)
    }
    
    private(set) var stringForKeyValues: (called: Bool, defaultName: String?) = (false, nil)
    func string(forKey defaultName: String) -> String? {
        self.stringForKeyValues = (true, defaultName)
        return (self.setAnyValueDictionary[defaultName] as? String) ?? nil
    }
    
    private(set) var objectForKeyValues: (called: Bool, defaultName: String?) = (false, nil)
    var objectForKey: Any?
    func object(forKey defaultName: String) -> Any? {
        self.objectForKeyValues = (true, defaultName)
        return self.objectForKey
    }
}
// swiftlint:enable large_tuple
