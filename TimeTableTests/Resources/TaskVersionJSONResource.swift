//
//  TaskHistoryJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum TaskVersionJSONResource: String, JSONFileResource {
    case taskVersionFullModel
    
    case taskVersionUnknownEvent
    case taskVersionNullEvent
    case taskVersionMissingEventKey
    
    case taskVersionNullPreviousProjectName
    case taskVersionMissingPreviousProjectNameKey
    case taskVersionNullCurrentProjectName
    case taskVersionMissingCurrentProjectNameKey
    case taskVersionNullProjectName
    case taskVersionMissingProjectNameKeys
    
    case taskVersionNullPreviousBody
    case taskVersionMissingPreviousBodyKey
    case taskVersionNullCurrentBody
    case taskVersionMissingCurrentBodyKey
    
    case taskVersionNullPreviousStartsAt
    case taskVersionMissingPreviousStartsAtKey
    case taskVersionNullCurrentStartsAt
    case taskVersionMissingCurrentStartsAtKey
    
    case taskVersionNullPreviousEndsAt
    case taskVersionMissingPreviousEndsAtKey
    case taskVersionNullCurrentEndsAt
    case taskVersionMissingCurrentEndsAtKey
    
    case taskVersionNullPreviousTag
    case taskVersionMissingPreviousTagKey
    case taskVersionNullCurrentTag
    case taskVersionMissingCurrentTagKey
    
    case taskVersionNullPreviousDuration
    case taskVersionMissingPreviousDurationKey
    case taskVersionNullCurrentDuration
    case taskVersionMissingCurrentDurationKey
    
    case taskVersionNullPreviousTask
    case taskVersionMissingPreviousTaskKey
    case taskVersionNullCurrentTask
    case taskVersionMissingCurrentTaskKey
    
    case taskVersionNullPreviousTaskPreview
    case taskVersionMissingPreviousTaskPreviewKey
    case taskVersionNullCurrentTaskPreview
    case taskVersionMissingCurrentTaskPreviewKey
    
    // MARK: Helper
    case taskUnchangedResponse
    case taskChangedProjectResponse
    case taskChangedBodyResponse
    case taskChangedStartsAtResponse
    case taskChangedEndsAtResponse
    case taskChangedTagResponse
    case taskChangedDurationResponse
    case taskChangedTaskResponse
    case taskChangedTaskPreviewResponse
}
