//
//  SimpleProjectRecordDecoder.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 21/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

struct SimpleProjectRecordDecoder: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case autofill
        case isInternal = "internal"
        case countDuration
        case isActive = "active"
        case isLunch = "lunch"
        case workTimesAllowsTask
        case isTaggable = "taggable"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        if let colorHexString = try? container.decode(String.self, forKey: .color) {
            self.color = UIColor(hexString: colorHexString)
        } else {
            self.color = nil
        }
        self.autofill = try? container.decode(Bool.self, forKey: .autofill)
        self.countDuration = try? container.decode(Bool.self, forKey: .countDuration)
        self.isActive = try? container.decode(Bool.self, forKey: .isActive)
        self.isInternal = try? container.decode(Bool.self, forKey: .isInternal)
        self.isLunch = try container.decode(Bool.self, forKey: .isLunch)
        self.workTimesAllowsTask = try container.decode(Bool.self, forKey: .workTimesAllowsTask)
        self.isTaggable = try container.decode(Bool.self, forKey: .isTaggable)
    }
}

// MARK: - Equatable
extension SimpleProjectRecordDecoder: Equatable {
    public static func == (lhs: SimpleProjectRecordDecoder, rhs: SimpleProjectRecordDecoder) -> Bool {
        return lhs.id == rhs.id
    }
}
