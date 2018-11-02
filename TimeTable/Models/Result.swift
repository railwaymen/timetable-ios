//
//  Result.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}
