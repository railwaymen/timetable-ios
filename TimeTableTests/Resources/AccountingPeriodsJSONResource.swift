//
//  AccountingPeriodsJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum AccountingPeriodsJSONResource: String, JSONFileResource {
    case accountingPeriodsResponseFullResponse
    
    case accountingPeriodFullResponse
    case accountingPeriodStartsAtNullValue
    case accountingPeriodMissingStartsAtKey
    case accountingPeriodEndsAtNullValue
    case accountingPeriodMissingEndsAtKey
    case accountingPeriodCountedDurationNullValue
    case accountingPeriodMissingCountedDurationKey
    case accountingPeriodNoteNullValue
    case accountingPeriodMissingNoteKey
}
