//
//  SignInValidationErrorResponse.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 13/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum SignInValidationErrorResponse: String, JSONFileResource {
    case signInValidationErrorEmptyBase
    case signInValidationErrorBaseInvalidEmailOrPassword
    case signInValidationErrorBaseInactive
    case signInValidationErrorFullModel
}
