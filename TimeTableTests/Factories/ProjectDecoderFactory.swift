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
    
    func build(
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
    ) throws -> ProjectDecoder {
        let jsonConvertible: AnyJSONConvertible = [
            "id": AnyJSONConvertible(identifier),
            "name": AnyJSONConvertible(name),
            "color": AnyJSONConvertible(color),
            "autofill": AnyJSONConvertible(autofill),
            "internal": AnyJSONConvertible(isInternal),
            "count_duration": AnyJSONConvertible(countDuration),
            "active": AnyJSONConvertible(isActive),
            "lunch": AnyJSONConvertible(isLunch),
            "work_times_allows_task": AnyJSONConvertible(workTimesAllowsTask),
            "taggable": AnyJSONConvertible(isTaggable)
        ]
        return try self.buildObject(of: jsonConvertible)
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
