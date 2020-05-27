//
//  DeleteRemoteWorkValidationError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 27/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct DeleteRemoteWorkValidationError: Error, ValidationErrorType {
    let startsAt: [StartsAtErrorKey]
    
    var isEmpty: Bool {
        self.startsAt.isEmpty
    }
    
    private enum CodingKeys: String, CodingKey {
        case startsAt = "starts_at"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let startsAt = try? container.decode([BasicError<StartsAtErrorKey>].self, forKey: .startsAt)
        self.startsAt = startsAt?.map(\.error) ?? []
    }
}

// MARK: - Structures
extension DeleteRemoteWorkValidationError {
    enum StartsAtErrorKey: String, Decodable {
        case tooOld = "too_old"
    }
}

// MARK: - LocalizedDescribable
extension DeleteRemoteWorkValidationError: LocalizedDescribable {
    var localizedDescription: String {
        return self.localizedDescriptions.first ?? ""
    }
    
    private var localizedDescriptions: [String] {
        return self.startsAt.map(\.localizedDescription)
    }
}

extension DeleteRemoteWorkValidationError.StartsAtErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .tooOld:
            return R.string.localizable.deleteremotework_error_startsAt_tooOld()
        }
    }
}
