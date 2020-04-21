//
//  ProjectTagsDecoderFactory.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 20/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class ProjectTagsDecoderFactory: JSONFactorable {
    func build(tags: [ProjectTag]) throws -> ProjectTagsDecoder {
        return try self.buildObject(of: Wrapper(tags: tags).jsonConvertible())
    }
}

// MARK: - Structure
extension ProjectTagsDecoderFactory {
    fileprivate struct Wrapper {
        let tags: [ProjectTag]
        
        func jsonConvertible() -> AnyJSONConvertible {
            return AnyJSONConvertible(self.tags.map { AnyJSONConvertible($0.rawValue) })
        }
    }
}

// MARK: - JSONObjectType
extension ProjectTagsDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        return ProjectTagsDecoderFactory.Wrapper(tags: self.tags).jsonConvertible()
    }
}
