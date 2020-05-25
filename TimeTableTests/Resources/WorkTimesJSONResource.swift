//
//  WorkTimesJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

enum WorkTimesJSONResource: String, JSONFileResource {
    case workTimeResponse
    case workTimeInvalidDateFormatResponse
    case workTimeNullUpdatedByAdmin
    case workTimeMissingKeyUpdatedByAdmin
    case workTimeBodyNull
    case workTimeMissingBodyKey
    case workTimeNullTask
    case workTimeMissingTaskKey
    case workTimeNullTaskPreview
    case workTimeMissingTaskPreviewKey
    
    case workTimesResponse
    case workTimesResponseNotSorted
}
