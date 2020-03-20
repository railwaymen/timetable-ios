//
//  AppError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum AppError: Error {
    case cannotRemeberUserCredentials(error: Error)
    case internalError
}

// MARK: - Equatable
extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.cannotRemeberUserCredentials, .cannotRemeberUserCredentials): return true
        case (.internalError, .internalError): return true
        default: return false
        }
    }
}
