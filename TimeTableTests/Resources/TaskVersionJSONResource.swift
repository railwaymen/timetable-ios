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
    
    case taskVersionUpdateEvent
    case taskVersionCreateEvent
    case taskVersionUnknownEvent
    case taskVersionNullEvent
    case taskVersionMissingEventKey
    
    case taskVersionChangesetProjectChanged
    case taskVersionChangesetStartsAtChanged
    case taskVersionChangesetEndsAtChanged
    case taskVersionChangesetDurationChanged
    case taskVersionChangesetBodyChanged
    case taskVersionChangesetTaskChanged
    case taskVersionChangesetTaskPreviewChanged
    case taskVersionChangesetDateChanged
    case taskVersionChangesetTagChanged
    case taskVersionChangesetEmpty
    case taskVersionChangesetUnknownValue
}
