//
//  MatchingFullTimeJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

enum MatchingFullTimeJSONResource: String, JSONFileResource {
    case matchingFullTimeFullResponse
    case matchingFullTimeNullPeriod
    case matchingFullTimeMissingPeriodKey
    case matchingFullTimeNullShouldWorked
    case matchingFullTimeMissingShouldWorkedKey
}
