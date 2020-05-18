//
//  NewVacationValidationErrorResponse.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 11/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum NewVacationValidationErrorResponse: String, JSONFileResource {
    case newVacationValidationErrorEmpty
    case newVacationValidationErrorBase
    case newVacationValidationErrorBaseWorkTimeExists
    case newVacationValidationErrorDescriptionBlank
    case newVacationValidationErrorStartDateBlank
    case newVacationValidationErrorStartDateGreaterThanEndDate
    case newVacationValidationErrorEndDateBlank
    case newVacationValidationErrorVacationTypeBlank
    case newVacationValidationErrorVacationTypeInclusion
    case newVacationValidationErrorFullModel
}
