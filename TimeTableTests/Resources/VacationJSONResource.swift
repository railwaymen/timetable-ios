//
//  VacationJSONResource.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum VacationJSONResource: String, JSONFileResource {
    
    // VacationType
    case vacationPlannedTypeResponse
    case vacationRequestedTypeResponse
    case vacationCompassionateTypeResponse
    case vacationOthersTypeResponse
    
    // Status
    case vacationUnconfirmedStatusResponse
    case vacationDeclinedStatusResponse
    case vacationApprovedStatusResponse
    case vacationAcceptedStatusResponse
}
