//
//  ApiValidationJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

enum ApiValidationJSONResource: String, JSONFileResource {
    case emptyErrosKeysResponse
    case baseErrorKeyResponse
    case startAtErrorKeyResponse
    case endsAtErrorKeyResponse
    case durationErrorKeyResponse
    case invalidEmailOrPasswordErrorKeyResponse
    case serverErrorResponse
}
