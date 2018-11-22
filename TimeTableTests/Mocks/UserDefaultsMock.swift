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
        boolForKeyValues = (true, defaultName)
        return setBoolValueDictionary[defaultName] ?? false
    }
    
    private(set) var removeObjectValues: (called: Bool, defaultName: String?) = (false, nil)
    func removeObject(forKey defaultName: String) {
        setAnyValueDictionary.removeValue(forKey: defaultName)
        setBoolValueDictionary.removeValue(forKey: defaultName)
        removeObjectValues = (true, defaultName)
    }
    
    private(set) var setAnyValues: (called: Bool, value: Any?, defaultName: String?) = (false, nil, nil)
    func set(_ value: Any?, forKey defaultName: String) {
        setAnyValueDictionary[defaultName] = value
        setAnyValues = (true, value, defaultName)
    }
    
    private(set) var setBoolValues: (called: Bool, defaultName: String?) = (false, nil)
    func set(_ value: Bool, forKey defaultName: String) {
        setBoolValueDictionary[defaultName] = value
        setBoolValues = (true, defaultName)
    }
    
    private(set) var stringForKeyValues: (called: Bool, defaultName: String?) = (false, nil)
    func string(forKey defaultName: String) -> String? {
        stringForKeyValues = (true, defaultName)
        return (setAnyValueDictionary[defaultName] as? String) ?? nil
    }
    
    private(set) var objectForKeyValues: (called: Bool, defaultName: String?) = (false, nil)
    var objectForKey: Any?
    func object(forKey defaultName: String) -> Any? {
        objectForKeyValues = (true, defaultName)
        return objectForKey
    }
}
// swiftlint:enable large_tuple
