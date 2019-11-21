//
//  ErrorHandlerType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

public typealias HandleAction<T> = (T) throws -> Void

public protocol ErrorHandlerType: class {
    func throwing(error: Error, finally: @escaping (Bool) -> Void)
    func catchingError(action: @escaping HandleAction<Error>) -> ErrorHandlerType
}

extension ErrorHandlerType {
    func throwing(error: Error) {
        self.throwing(error: error, finally: { _ in })
    }
}
