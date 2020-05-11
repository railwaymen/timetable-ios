//
//  RegisterRemoteWorkValidationError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct RegisterRemoteWorkValidationError: Error, ValidationErrorType {
    let startsAt: [StartsAtErrorKey]
    let endsAt: [EndsAtErrorKey]

    private enum CodingKeys: String, CodingKey {
        case startsAt = "starts_at"
        case endsAt = "ends_at"
    }
    
    var isEmpty: Bool {
        self.startsAt.isEmpty && self.endsAt.isEmpty
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let startsAt = try? container.decode([BasicError<StartsAtErrorKey>].self, forKey: .startsAt)
        self.startsAt = startsAt?.map(\.error) ?? []
        let endsAt = try? container.decode([BasicError<EndsAtErrorKey>].self, forKey: .endsAt)
        self.endsAt = endsAt?.map(\.error) ?? []
    }
}

// MARK: - Structures
extension RegisterRemoteWorkValidationError {
    enum StartsAtErrorKey: String, Decodable {
        case overlap
        case tooOld = "too_old"
        case blank
        case incorrectHours = "incorrect_hours"
    }

    enum EndsAtErrorKey: String, Decodable {
        case blank
    }
}

// MARK: - ValidationErrorUIRepresentable
extension RegisterRemoteWorkValidationError: ValidationErrorUIRepresentable {
    var uiErrors: [UIError] {
        return self.startsAt.map(\.uiError) + self.endsAt.map(\.uiError)
    }
}

// MARK: - UIErrorRepresentable
extension RegisterRemoteWorkValidationError.StartsAtErrorKey: UIErrorRepresentable {
    var uiError: UIError {
        switch self {
        case .overlap: return UIError.remoteWorkStartsAtOvelap
        case .tooOld: return UIError.remoteWorkStartsAtTooOld
        case .blank: return UIError.remoteWorkStartsAtEmpty
        case .incorrectHours: return UIError.remoteWorkStartsAtIncorrectHours
        }
    }
}

extension RegisterRemoteWorkValidationError.EndsAtErrorKey: UIErrorRepresentable {
    var uiError: UIError {
        switch self {
        case .blank: return UIError.remoteWorkEndsAtEmpty
        }
    }
}
