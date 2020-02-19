//
//  UIErrors.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum UIElement: String {
    case serverAddressTextField = "element.text_field.server_address"
    case loginTextField = "element.text_field.login"
    case passwordTextField = "element.text_field.password"
    case projectTextField = "element.text_field.project"
    case dayTextField = "element.text_field.day"
    case taskNameTextField = "element.text_field.task_name"
    case taskUrlTextField = "element.text_field.task_url"
    case startsAtTextField = "element.text_field.starts_at"
    case endsAtTextField = "element.text_field.ends_at"
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
            return "\(component.rawValue.localized) " + "ui.error.cannot_be_empty".localized
        case let .invalidFormat(component):
            return "\(component.rawValue.localized) " + "ui.error.invalid_format".localized
        case .timeGreaterThan:
            return "ui.error.time_greater_than".localized
        case .genericError:
            return "ui.error.generic_error".localized
        case .loginCredentialsInvalid:
            return "ui.error.login_credentials_invalid".localized
        }
    }
}

// MARK: - Equatable
extension UIError: Equatable {}
