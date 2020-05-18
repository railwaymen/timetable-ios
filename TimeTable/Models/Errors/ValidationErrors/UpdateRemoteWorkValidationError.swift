//
//  UpdateRemoteWorkValidationError.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct UpdateRemoteWorkValidationError: Error, ValidationErrorType {
    let startsAt: [StartsAtErrorKey]
    let endsAt: [EndsAtErrorKey]
    
    var isEmpty: Bool {
        return self.startsAt.isEmpty
            && self.endsAt.isEmpty
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
extension UpdateRemoteWorkValidationError {
    enum StartsAtErrorKey: String, Decodable {
        case overlap
        case overlapMidnight = "overlap_midnight"
        case tooOld = "too_old"
        case blank
        case incorrectHours = "incorrect_hours"
    }
    
    enum EndsAtErrorKey: String, Decodable {
        case blank
    }
}

// MARK: - LocalizedDescribable
extension UpdateRemoteWorkValidationError: LocalizedDescribable {
    var localizedDescription: String {
        return self.localizedDescriptions.first ?? ""
    }
    
    private var localizedDescriptions: [String] {
        return self.startsAt.map(\.localizedDescription) + self.endsAt.map(\.localizedDescription)
    }
}

extension UpdateRemoteWorkValidationError.StartsAtErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .overlap:
            return R.string.localizable.registerremotework_error_startsAt_overlap()
        case .overlapMidnight:
            return R.string.localizable.registerremotework_error_startsAt_overlapMidnight()
        case .tooOld:
            return R.string.localizable.registerremotework_error_startsAt_tooOld()
        case .blank:
            return R.string.localizable.registerremotework_error_startsAt_empty()
        case .incorrectHours:
            return R.string.localizable.registerremotework_error_startsAt_incorrectHours()
        }
    }
}

extension UpdateRemoteWorkValidationError.EndsAtErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .blank:
            return R.string.localizable.registerremotework_error_endsAt_empty()
        }
    }
}
