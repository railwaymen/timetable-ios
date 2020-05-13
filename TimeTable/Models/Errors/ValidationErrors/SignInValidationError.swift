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

// MARK: - LocalizedDescribable
extension SignInValidationError: LocalizedDescribable {
    var localizedDescription: String {
        return self.localizedDescriptions.first ?? ""
    }
    
    private var localizedDescriptions: [String] {
        return self.base.map(\.localizedDescription)
    }
}

extension SignInValidationError.BaseErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .invalidEmailOrPassword:
            return R.string.localizable.credential_error_credentials_invalid()
        case .inactive:
            return R.string.localizable.credential_error_inactive()
        }
    }
}
