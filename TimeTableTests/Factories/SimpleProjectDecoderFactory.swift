//
//  SimpleProjectDecoderFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 21/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class SimpleProjectDecoderFactory: JSONFactorable {
    func build(wrapper: SimpleProjectDecoderWrapper = SimpleProjectDecoderWrapper()) throws -> SimpleProjectDecoder {
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension SimpleProjectDecoderFactory {
    struct SimpleProjectDecoderWrapper {
        let projects: [SimpleProjectRecordDecoder]
        let tags: [ProjectTag]
        
        init(
            projects: [SimpleProjectRecordDecoder] = [],
            tags: [ProjectTag] = []
        ) {
            self.projects = projects
            self.tags = tags
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "projects": AnyJSONConvertible(self.projects),
                "tags": AnyJSONConvertible(self.tags)
            ]
        }
    }
}

// MARK: - Helper extensions
extension SimpleProjectDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = SimpleProjectDecoderFactory.SimpleProjectDecoderWrapper(
            projects: self.projects,
            tags: self.tags)
        return wrapper.jsonConvertible()
    }
}

extension ProjectTag: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        return self.rawValue
    }
}
