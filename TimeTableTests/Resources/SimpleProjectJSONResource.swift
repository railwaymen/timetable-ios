//
//  SimpleProjectJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

enum SimpleProjectJSONResource: String, JSONFileResource {
    case simpleProjectFullResponse
    case simpleProjectNullColorResponse
    case simpleProjectMissingColorKeyResponse
    case simpleProjectNullAutofillResponse
    case simpleProjectMissingAutofillKeyResponse
    case simpleProjectNullInternalResponse
    case simpleProjectMissingInternalKeyResponse
    case simpleProjectNullCountDurationResponse
    case simpleProjectMissingCountDurationKeyResponse
    case simpleProjectNullActiveResponse
    case simpleProjectMissingActiveKeyResponse
    case simpleProjectNullLunchResponse
    case simpleProjectMissingLunchKeyResponse
    case simpleProjectNullWorkTimesAllowsTaskResponse
    case simpleProjectMissingWorkTimesAllowsTaskKeyResponse
    
    case simpleProjectWithAutofillTrueResponse
    case simpleProjectWithALunchTrueResponse
    case simpleProjectWithIsTaggableTrueResponse
    case simpleProjectWithIsTaggableFalseResponse
    
    case simpleProjectArrayResponse
}
