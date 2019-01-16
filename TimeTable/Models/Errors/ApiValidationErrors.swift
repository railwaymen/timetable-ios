//
//  ApiValidationErrors.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct ApiValidationErrors: Error, Decodable, Equatable {
    let errors: Base

    struct Base: Decodable, Equatable {
        var keys: [String]
        
        enum CodingKeys: String, CodingKey {
            case base
            case startsAt = "starts_at"
            case endsAt = "ends_at"
            case duration
            case invalidEmailOrPassword = "invalid_email_or_password"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.keys = []
            if let base = try? container.decode([String].self, forKey: .base) {
                self.keys += base
            }
            if let startsAt = try? container.decode([String].self, forKey: .startsAt) {
                self.keys += startsAt
            }
            if let endsAt = try? container.decode([String].self, forKey: .endsAt) {
                self.keys += endsAt
            }
            if let duration = try? container.decode([String].self, forKey: .duration) {
                self.keys += duration
            }
            if let invalidEmailOrPassword = (try? container.decode([String].self, forKey: .invalidEmailOrPassword)) {
                self.keys += invalidEmailOrPassword
            }
        }
        
        // MARK: - Equatable
        static func == (lhs: Base, rhs: Base) -> Bool {
            return lhs.keys == rhs.keys
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case errors
    }
    
    // MARK: - Equatable
    static func == (lhs: ApiValidationErrors, rhs: ApiValidationErrors) -> Bool {
        return lhs.errors == rhs.errors
    }
}
