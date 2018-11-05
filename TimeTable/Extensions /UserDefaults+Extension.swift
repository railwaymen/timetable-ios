//
//  UserDefaults+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol UserDefaultsType {
    func bool(forKey defaultName: String) -> Bool
    func removeObject(forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    func set(_ value: Bool, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaultsType {}
