//
//  RegisterRemoteWorkValidationResource.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum RegisterRemoteWorkValidationResponse: String, JSONFileResource {
    case registerRemoteEmptyStartsAtAndEndsAtResponse
    
    case registerRemoteStartsAtFullModelResponse
    case registerRemoteEndsAtFullModelResponse
    case registerRemoteStartsAtOverlapResponse
    case registerRemoteStartsAtTooOldResponse
    case registerRemoteStartsAtEmptyResponse
    case registerRemoteStartsAtIncorrectHoursResponse
    
    case registerRemoteFullModelResponse
}
