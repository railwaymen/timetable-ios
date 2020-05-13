//
//  SignInValidationError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 13/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct SignInValidationError: Error, ValidationErrorType {
    let base: [BaseErrorKey]
    
    private var localizedDescriptions: [String] {
        return self.base.map(\.localizedDescription)
    }

    var isEmpty: Bool {
        self.base.isEmpty
    }
    
    private enum CodingKeys: String, CodingKey {
        case base
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try? container.decode([BasicError<BaseErrorKey>].self, forKey: .base)
        self.base = base?.map(\.error) ?? []
    }
}

// MARK: - Structures
extension SignInValidationError {
    enum BaseErrorKey: String, Decodable {
        case invalidEmailOrPassword = "invalid_email_or_password"
        case inactive
    }
}

// MARK: - LocalizedDescriptionable
extension SignInValidationError: LocalizedDescriptionable {
    var localizedDescription: String {
        return self.localizedDescriptions.first ?? ""
    }
}

extension SignInValidationError.BaseErrorKey: LocalizedDescriptionable {
    var localizedDescription: String {
        switch self {
        case .invalidEmailOrPassword:
            return R.string.localizable.credential_error_credentials_invalid()
        case .inactive:
            return R.string.localizable.credential_error_inactive()
        }
    }
}
