//
//  ProjectDecoderFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class ProjectDecoderFactory: JSONFactorable {
    func build(wrapper: ProjectDecoderWrapper = ProjectDecoderWrapper()) throws -> ProjectDecoder {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension ProjectDecoderFactory {
    struct ProjectDecoderWrapper {
        let identifier: Int
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
            identifier: Int = 0,
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
            self.identifier = identifier
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
                "id": AnyJSONConvertible(self.identifier),
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
extension ProjectDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = ProjectDecoderFactory.ProjectDecoderWrapper(
            identifier: self.identifier,
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
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let hexRed = String(Int(red * 255), radix: 16)
        let hexGreen = String(Int(green * 255), radix: 16)
        let hexBlue = String(Int(blue * 255), radix: 16)
        return hexRed + hexGreen + hexBlue
    }
}
