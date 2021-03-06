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
    
    var isEmpty: Bool {
        self.startsAt.isEmpty && self.endsAt.isEmpty
    }
    
    private enum CodingKeys: String, CodingKey {
        case startsAt = "starts_at"
        case endsAt = "ends_at"
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

// MARK: - LocalizedDescribable
extension RegisterRemoteWorkValidationError: LocalizedDescribable {
    var localizedDescription: String {
        return self.localizedDescriptions.first ?? ""
    }
    
    private var localizedDescriptions: [String] {
        return self.startsAt.map(\.localizedDescription) + self.endsAt.map(\.localizedDescription)
    }
}

extension RegisterRemoteWorkValidationError.StartsAtErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .overlap:
            return R.string.localizable.registerremotework_error_startsAt_overlap()
        case .tooOld:
            return R.string.localizable.registerremotework_error_startsAt_tooOld()
        case .blank:
            return R.string.localizable.registerremotework_error_startsAt_empty()
        case .incorrectHours:
            return R.string.localizable.registerremotework_error_startsAt_incorrectHours()
        }
    }
}

extension RegisterRemoteWorkValidationError.EndsAtErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .blank:
            return R.string.localizable.registerremotework_error_endsAt_empty()
        }
    }
}
