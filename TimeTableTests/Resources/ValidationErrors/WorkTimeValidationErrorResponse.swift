//
//  WorkTimeValidationErrorResponse.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 14/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum WorkTimeValidationErrorResponse: String, JSONFileResource {
    case workTimeValidationErrorEmptyResponse
    case workTimeValidationErrorBodyOrTaskBlank
    case workTimeValidationErrorTaskInvalidURI
    case workTimeValidationErrorTaskInvalidExternal
    case workTimeValidationErrorStartsAtOverlap
    case workTimeValidationErrorStartsAtTooOld
    case workTimeValidationErrorStartsAtOverlapMidnight
    case workTimeValidationErrorStartsAtNoGapsToFill
    case workTimeValidationErrorDurationGreaterThan
    case workTimeValidationErrorProjectIDBlank
    case workTimeValidationErrorFullModel
}
