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
}

enum UIError: Error {
    case cannotBeEmpty(UIElement)
    case invalidFormat(UIElement)
    
    var localizedDescription: String {
        
        switch self {
        case .cannotBeEmpty(let component):
            return "\(component.rawValue.localized) " + "ui.error.cannot_be_empty".localized
        case .invalidFormat(let component):
            return "\(component.rawValue.localized) " + "ui.error.invalid_format".localized
        }
    }
}

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
