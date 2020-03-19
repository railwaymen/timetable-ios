//
//  ProjectRecordJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

enum ProjectRecordJSONResource: String, JSONFileResource {
    case projectRecordResponse
    case projectRecordNullColorResponse
    case projectRecordMissingColorKeyResponse
    
    case projectRecordNullLeaderFirstNameResponse
    case projectRecordMissingLeaderFirstNameKeyResponse
    case projectRecordNullLeaderLastNameResponse
    case projectRecordMissingLeaderLastNameKeyResponse
    
    case projectRecordNullUsersResponse
    case projectRecordMissingUsersKeyResponse
    
    case projectsRecordsResponse
}
