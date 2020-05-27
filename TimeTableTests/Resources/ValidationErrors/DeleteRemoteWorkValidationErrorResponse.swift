//
//  DeleteRemoteWorkValidationErrorResponse.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 27/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum DeleteRemoteWorkValidationErrorResponse: String, JSONFileResource {
    case deleteRemoteWorkValidationErrorEmpty
    case deleteRemoteWorkValidationStartsAtTooOld
}
