//
//  ApiClientError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum ApiClientError: Error {
    case invalidParameters
    case invalidBaseURL(URL?)
    case invalidResponse
}
