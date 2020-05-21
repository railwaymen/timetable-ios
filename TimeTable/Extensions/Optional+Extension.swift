//
//  Optional+Extension.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 21/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

extension Optional {
    func unwrapped(using errorHandler: ErrorHandlerType, file: StaticString = #file, line: UInt = #line) -> Self {
        guard let self = self else {
            let errorMessage = "Unexpectedly found nil while safely unwrapping an optional value"
            errorHandler.stopInDebug(errorMessage, file: file, line: line)
            return nil
        }
        return self
    }
}
