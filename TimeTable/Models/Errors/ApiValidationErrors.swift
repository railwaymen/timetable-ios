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
        let keys: [BasicErrorInfo]
        
        enum CodingKeys: String, CodingKey {
            case base
            case task
            case startsAt = "starts_at"
            case endsAt = "ends_at"
            case duration
            case invalidEmailOrPassword = "invalid_email_or_password"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var keys: [BasicErrorInfo] = []
            if let base = try? container.decode([BasicErrorInfo].self, forKey: .base) {
                keys += base
            }
            if let task = try? container.decode([BasicErrorInfo].self, forKey: .task) {
                keys += task
            }
            if let startsAt = try? container.decode([BasicErrorInfo].self, forKey: .startsAt) {
                keys += startsAt
            }
            if let endsAt = try? container.decode([BasicErrorInfo].self, forKey: .endsAt) {
                keys += endsAt
            }
            if let duration = try? container.decode([BasicErrorInfo].self, forKey: .duration) {
                keys += duration
            }
            if let invalidEmailOrPassword = try? container.decode([BasicErrorInfo].self, forKey: .invalidEmailOrPassword) {
                keys += invalidEmailOrPassword
            }
            self.keys = keys
        }
    }
    
    struct BasicErrorInfo: Decodable, Equatable {
        let error: String
        
        var errorKey: ErrorKey? {
            ErrorKey(rawValue: self.error)
        }
        
        var localizedDescription: String? {
            self.errorKey?.localizedDescription
        }
    }
    
    enum ErrorKey: String {
        case overlap
        case invalidURI = "invalid_uri"
        case invalidExternal = "invalid_external"
        case tooOld = "too_old"
        case noGapsToFill = "no_gaps_to_fill"
        
        var localizedDescription: String {
            switch self {
            case .overlap:
                return R.string.localizable.worktimeform_error_overlap()
            case .invalidURI:
                return R.string.localizable.worktimeform_error_invalid_uri()
            case .invalidExternal:
                return R.string.localizable.worktimeform_error_invalid_external()
            case .tooOld:
                return R.string.localizable.worktimeform_error_too_old()
            case .noGapsToFill:
                return R.string.localizable.worktimeform_error_no_gaps_to_fill()
            }
        }
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
