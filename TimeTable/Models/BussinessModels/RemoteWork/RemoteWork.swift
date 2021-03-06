//
//  RemoteWork.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct RemoteWork: Decodable {
    let id: Int
    let creatorID: Int
    let startsAt: Date
    let endsAt: Date
    let duration: TimeInterval
    let note: String?
    let updatedByAdmin: Bool
    let userID: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case creatorID = "creator_id"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case duration
        case note
        case updatedByAdmin = "updated_by_admin"
        case userID = "user_id"
    }
}

// MARK: - Equatable
extension RemoteWork: Equatable {
    static func == (lhs: RemoteWork, rhs: RemoteWork) -> Bool {
        return lhs.id == rhs.id
    }
}
