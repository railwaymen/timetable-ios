//
//  TaskValidationError.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 19/12/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

enum TaskValidationError: Error {
    case projectIsNil
    case urlIsNil
    case bodyIsEmpty
    case startsAtIsNil
    case endsAtIsNil
    case timeRangeIsIncorrect
}
