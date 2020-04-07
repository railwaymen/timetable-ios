//
//  ApiValidationErrors.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct ApiValidationErrors: Error, Decodable {
    let errors: Base
}

// MARK: - Structures
extension ApiValidationErrors {
    struct Base: Decodable {
        let keys: [String]
        
        enum CodingKeys: String, CodingKey {
            case base
            case startsAt
            case endsAt
            case duration
            case invalidEmailOrPassword
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var keys: [String] = []
            if let base = try? container.decode([BasicErrorInfo].self, forKey: .base) {
                keys += base.map(\.error)
            }
            if let startsAt = try? container.decode([BasicErrorInfo].self, forKey: .startsAt) {
                keys += startsAt.map(\.error)
            }
            if let endsAt = try? container.decode([BasicErrorInfo].self, forKey: .endsAt) {
                keys += endsAt.map(\.error)
            }
            if let duration = try? container.decode([BasicErrorInfo].self, forKey: .duration) {
                keys += duration.map(\.error)
            }
            if let invalidEmailOrPassword = try? container.decode([BasicErrorInfo].self, forKey: .invalidEmailOrPassword) {
                keys += invalidEmailOrPassword.map(\.error)
            }
            self.keys = keys
        }
    }
    
    private struct BasicErrorInfo: Decodable {
        let error: String
    }
}

// MARK: - Equatable
extension ApiValidationErrors: Equatable {
    static func == (lhs: ApiValidationErrors, rhs: ApiValidationErrors) -> Bool {
        return lhs.errors == rhs.errors
    }
}

extension ApiValidationErrors.Base: Equatable {
    static func == (lhs: ApiValidationErrors.Base, rhs: ApiValidationErrors.Base) -> Bool {
        return lhs.keys == rhs.keys
    }
}
