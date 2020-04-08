//
//  UIErrors.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum UIElement {
    case serverAddressTextField
    case loginTextField
    case passwordTextField
    case projectTextField
    case dayTextField
    case taskNameTextField
    case taskUrlTextField
    case startsAtTextField
    case endsAtTextField
    
    var localized: String {
        switch self {
        case .serverAddressTextField:
            return R.string.localizable.elementText_fieldServer_address()
        case .loginTextField:
            return R.string.localizable.elementText_fieldLogin()
        case .passwordTextField:
            return R.string.localizable.elementText_fieldPassword()
        case .projectTextField:
            return R.string.localizable.elementText_fieldProject()
        case .dayTextField:
            return R.string.localizable.elementText_fieldDay()
        case .taskNameTextField:
            return R.string.localizable.elementText_fieldTask_name()
        case .taskUrlTextField:
            return R.string.localizable.elementText_fieldTask_url()
        case .startsAtTextField:
            return R.string.localizable.elementText_fieldStarts_at()
        case .endsAtTextField:
            return R.string.localizable.elementText_fieldEnds_at()
        }
    }
}

enum UIError: Error {
    case cannotBeEmpty(UIElement)
    case invalidFormat(UIElement)
    case timeGreaterThan
    case genericError
    case loginCredentialsInvalid
    
    var localizedDescription: String {
        switch self {
        case let .cannotBeEmpty(component):
            return R.string.localizable.uiErrorCannot_be_empty(component.localized)
        case let .invalidFormat(component):
            return R.string.localizable.uiErrorInvalid_format(component.localized)
        case .timeGreaterThan:
            return R.string.localizable.uiErrorTime_greater_than()
        case .genericError:
            return R.string.localizable.uiErrorGeneric_error()
        case .loginCredentialsInvalid:
            return R.string.localizable.uiErrorLogin_credentials_invalid()
        }
    }
}

// MARK: - Equatable
extension UIError: Equatable {}
