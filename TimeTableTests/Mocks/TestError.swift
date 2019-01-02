//
//  TestError.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

struct TestError: Error {
    let message: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.message == rhs.message
    }
}
