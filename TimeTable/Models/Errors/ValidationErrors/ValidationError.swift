//
//  ValidationError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

typealias ValidationErrorable = (ValidationErrorType & LocalizedDescribable)

protocol ValidationErrorType: Decodable {
    var isEmpty: Bool { get }
}

struct ValidationError<T: ValidationErrorable>: Error, RestlerErrorDecodable, Decodable {
    let errors: T

    private let decoder = JSONDecoder()
    
    private enum CodingKeys: String, CodingKey {
        case errors
    }
    
    // MARK: - Initialization
    init?(response: Restler.Response) {
        guard response.response?.statusCode == 422 else { return nil }
        guard let data = response.data else { return nil }
        do {
            let errors = try decoder.decode(Self.self, from: data)
            guard !errors.errors.isEmpty else { return nil }
            self.errors = errors.errors
        } catch {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errors = try container.decode(T.self, forKey: .errors)
    }
}

// MARK: - LocalizedDescribable
extension ValidationError: LocalizedDescribable {
    var localizedDescription: String {
        return self.errors.localizedDescription
    }
}
