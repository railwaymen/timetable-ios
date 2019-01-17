//
//  ProjectDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

struct ProjectDecoder: Decodable {
    let identifier: Int
    let name: String
    let color: UIColor?
    let autofill: Bool?
    let countDuration: Bool?
    let isActive: Bool?
    let isInternal: Bool?
    let isLunch: Bool
    let workTimesAllowsTask: Bool
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case color
        case autofill
        case isInternal = "internal"
        case countDuration = "count_duration"
        case isActive = "active"
        case isLunch = "lunch"
        case workTimesAllowsTask = "work_times_allows_task"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.name = try container.decode(String.self, forKey: .name)
        if let colorHexString = try? container.decode(String.self, forKey: .color) {
            self.color = UIColor(string: colorHexString)
        } else {
            self.color = nil
        }
        self.autofill = try? container.decode(Bool.self, forKey: .autofill)
        self.countDuration = try? container.decode(Bool.self, forKey: .countDuration)
        self.isActive = try? container.decode(Bool.self, forKey: .isActive)
        self.isInternal = try? container.decode(Bool.self, forKey: .isInternal)
        self.isLunch = try container.decode(Bool.self, forKey: .isLunch)
        self.workTimesAllowsTask = try container.decode(Bool.self, forKey: .workTimesAllowsTask)
    }
    
    init(identifier: Int, name: String, color: UIColor?, autofill: Bool?, countDuration: Bool?,
         isActive: Bool?, isInternal: Bool?, isLunch: Bool, workTimesAllowsTask: Bool) {
        self.identifier = identifier
        self.name = name
        self.color = color
        
        self.autofill = autofill
        self.countDuration = countDuration
        self.isActive = isActive
        self.isInternal = isInternal
        self.isLunch = isLunch
        self.workTimesAllowsTask = workTimesAllowsTask
    }
}

// MARK: - Equatable
extension ProjectDecoder: Equatable {
    public static func == (lhs: ProjectDecoder, rhs: ProjectDecoder) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name
            && lhs.color == rhs.color && lhs.autofill == rhs.autofill
            && lhs.countDuration == rhs.countDuration && lhs.isActive == rhs.isActive
            && lhs.isInternal == rhs.isInternal && lhs.isLunch == rhs.isLunch
            && lhs.workTimesAllowsTask == rhs.workTimesAllowsTask
    }
}
