//
//  BasicError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct BasicError<T: RawRepresentable & Decodable>: Decodable {
    let error: T
}
