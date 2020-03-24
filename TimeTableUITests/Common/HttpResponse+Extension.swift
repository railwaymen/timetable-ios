//
//  HttpResponse+Extension.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 26/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Swifter

extension HttpResponse {
    static func validationError(data: Data) -> HttpResponse {
        return .raw(422, "Validation error", nil, { writer in
            try writer.write(data)
        })
    }
}
