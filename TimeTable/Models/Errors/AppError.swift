//
//  AppError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum AppError: Error {
    case cannotRemeberUserCredentials(error: Error)
}
