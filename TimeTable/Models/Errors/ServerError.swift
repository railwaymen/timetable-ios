//
//  ServerError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 15/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct ServerError: Error {
    let error: String
    let status: Int
}

// MARK: - Decodable
extension ServerError: Decodable {
    enum CodingKeys: String, CodingKey {
        case error
        case status
    }
}

// MARK: - Equatable
extension ServerError: Equatable {
    static func == (lhs: ServerError, rhs: ServerError) -> Bool {
        return lhs.error == rhs.error && lhs.status == rhs.status
    }
}
