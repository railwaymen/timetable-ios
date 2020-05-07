//
//  RemoteWorkRequest.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct RemoteWorkRequest: Encodable {
    let note: String
    let startsAt: Date
    let endsAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case note
        case startsAt = "starts_at"
        case endsAt = "ends_at"
    }
}
