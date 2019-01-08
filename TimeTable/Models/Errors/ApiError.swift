//
//  ApiError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case invalidHost(URL?)
    
    var localizedDescription: String {
        switch self {
        case .invalidHost(let url):
            return String(format: "api.error.invalid_url".localized, url?.absoluteString ?? "")
        }
    }
}
