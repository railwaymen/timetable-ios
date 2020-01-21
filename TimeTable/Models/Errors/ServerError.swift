//
//  ServerError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 15/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct ServerError: Error, Decodable {
    let error: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case error
        case status
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decode(String.self, forKey: .error)
        self.status = try container.decode(Int.self, forKey: .status)
    }
}

// MARK: - Equatable
extension ServerError: Equatable {
    static func == (lhs: ServerError, rhs: ServerError) -> Bool {
        return lhs.error == rhs.error
            && lhs.status == rhs.status
    }
}
