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
    case taskNameTextField = "element.text_field.task_name"
    case taskUrlTextField = "element.text_field.task_url"
    case startsAtTextField = "element.text_field.starts_at"
    case endsAtTextField = "element.text_field.ends_at"
}

enum UIError: Error {
    case cannotBeEmptyOr(UIElement, UIElement)
    case cannotBeEmpty(UIElement)
    case invalidFormat(UIElement)
    case timeGreaterThan
    
    var localizedDescription: String {
        
        switch self {
        case .cannotBeEmptyOr(let component1, let component2):
            return "\(component1.rawValue.localized) " + "conjunction.or".localized + " \(component2.rawValue.localized) "
                + "ui.error.cannot_be_empty".localized
        case .cannotBeEmpty(let component):
            return "\(component.rawValue.localized) " + "ui.error.cannot_be_empty".localized
        case .invalidFormat(let component):
            return "\(component.rawValue.localized) " + "ui.error.invalid_format".localized
        case .timeGreaterThan:
            return "ui.error.time_greater_than".localized
        }
    }
}

// MARK: - Equatable
extension UIError: Equatable {
    static func == (lhs: UIError, rhs: UIError) -> Bool {
        switch (lhs, rhs) {
        case (.cannotBeEmpty(let lhsElement), .cannotBeEmpty(let rhsElement)):
            return lhsElement == rhsElement
        case (.invalidFormat(let lhsElement), .invalidFormat(let rhsElement)):
            return lhsElement == rhsElement
        default:
            return false
        }
    }
}
