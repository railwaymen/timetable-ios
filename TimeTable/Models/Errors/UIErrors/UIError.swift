//
//  UIErrors.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum UIError: Error {
    case cannotBeEmpty(UIElement)
    case invalidFormat(UIElement)
    case workTimeGreaterThan
    case genericError
    case remoteWorkStartsAtIncorrectHours
}

// MARK: - LocalizedDescribable
extension UIError: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .cannotBeEmpty:
            return R.string.localizable.error_cannot_be_empty()
        case .invalidFormat:
            return R.string.localizable.error_invalid_format()
        case .workTimeGreaterThan:
            return R.string.localizable.worktimeform_error_greater_than()
        case .genericError:
            return R.string.localizable.error_something_went_wrong()
        case .remoteWorkStartsAtIncorrectHours:
            return R.string.localizable.registerremotework_error_startsAt_incorrectHours()
        }
    }
}

// MARK: - Equatable
extension UIError: Equatable {}
