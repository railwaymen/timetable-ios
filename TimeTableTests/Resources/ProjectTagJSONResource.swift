//
//  ProjectTagJSONResource.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 20/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

enum ProjectTagJSONResource: String, JSONFileResource {
    case projectTagsResponse
    case projectTagsMissingResponse
    case projectTagsUnknownResponse
}
