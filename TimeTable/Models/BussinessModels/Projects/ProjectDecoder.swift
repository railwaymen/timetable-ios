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
    let workTimesAllowsTask: Bool
    let isLunch: Bool
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case color
        case workTimesAllowsTask = "work_times_allows_task"
        case isLunch = "lunch"
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
        self.workTimesAllowsTask = try container.decode(Bool.self, forKey: .workTimesAllowsTask)
        self.isLunch = try container.decode(Bool.self, forKey: .isLunch)
    }
    
    init(identifier: Int, name: String, color: UIColor?, workTimesAllowsTask: Bool, isLunch: Bool) {
        self.identifier = identifier
        self.name = name
        self.color = color
        self.workTimesAllowsTask = workTimesAllowsTask
        self.isLunch = isLunch
    }
}

extension ProjectDecoder: Equatable {
    
    // MARK: - Equatable
    public static func == (lhs: ProjectDecoder, rhs: ProjectDecoder) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name
            && lhs.color == rhs.color && lhs.workTimesAllowsTask == rhs.workTimesAllowsTask
            && lhs.isLunch == rhs.isLunch
    }
}
