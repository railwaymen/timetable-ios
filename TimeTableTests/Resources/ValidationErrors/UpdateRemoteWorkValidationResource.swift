//
//  UpdateRemoteWorkValidationResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum UpdateRemoteWorkValidationResource: String, JSONFileResource {
    case updateRemoteEmptyStartsAtAndEndsAtResponse
    
    case updateRemoteStartsAtFullModelResponse
    case updateRemoteEndsAtFullModelResponse
    case updateRemoteStartsAtOverlapResponse
    case updateRemoteStartsAtOverlapMidnightResponse
    case updateRemoteStartsAtTooOldResponse
    case updateRemoteStartsAtEmptyResponse
    case updateRemoteStartsAtIncorrectHoursResponse
    
    case updateRemoteFullModelResponse
}
