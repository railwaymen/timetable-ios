//
//  ServerError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 15/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct ServerError: Error, Decodable {
    let error: String
    let status: Int
}

// MARK: - Equatable
extension ServerError: Equatable {}
