//
//  SimpleProjectRecordDecoderFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class SimpleProjectRecordDecoderFactory: JSONFactorable {
    func build(wrapper: Wrapper = Wrapper()) throws -> SimpleProjectRecordDecoder {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension SimpleProjectRecordDecoderFactory {
    struct Wrapper {
        let id: Int
        let name: String
        let color: UIColor?
        let autofill: Bool?
        let countDuration: Bool?
        let isActive: Bool?
        let isInternal: Bool?
        let isLunch: Bool
        let workTimesAllowsTask: Bool
        let isTaggable: Bool
        
        init(
            id: Int = 0,
            name: String = "name",
            color: UIColor? = nil,
            autofill: Bool? = nil,
            countDuration: Bool? = nil,
            isActive: Bool? = nil,
            isInternal: Bool? = nil,
            isLunch: Bool = false,
            workTimesAllowsTask: Bool = false,
            isTaggable: Bool = false
        ) {
            self.id = id
            self.name = name
            self.color = color
            self.autofill = autofill
            self.countDuration = countDuration
            self.isActive = isActive
            self.isInternal = isInternal
            self.isLunch = isLunch
            self.workTimesAllowsTask = workTimesAllowsTask
            self.isTaggable = isTaggable
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.id),
                "name": AnyJSONConvertible(self.name),
                "color": AnyJSONConvertible(self.color),
                "autofill": AnyJSONConvertible(self.autofill),
                "internal": AnyJSONConvertible(self.isInternal),
                "count_duration": AnyJSONConvertible(self.countDuration),
                "active": AnyJSONConvertible(self.isActive),
                "lunch": AnyJSONConvertible(self.isLunch),
                "work_times_allows_task": AnyJSONConvertible(self.workTimesAllowsTask),
                "taggable": AnyJSONConvertible(self.isTaggable)
            ]
        }
    }
}

// MARK: - Helper extensions
extension SimpleProjectRecordDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = SimpleProjectRecordDecoderFactory.Wrapper(
            id: self.id,
            name: self.name,
            color: self.color,
            autofill: self.autofill,
            countDuration: self.countDuration,
            isActive: self.isActive,
            isInternal: self.isInternal,
            isLunch: self.isLunch,
            workTimesAllowsTask: self.workTimesAllowsTask,
            isTaggable: self.isTaggable)
        return wrapper.jsonConvertible()
    }
}

extension UIColor: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        return self.hexString()
    }
}
