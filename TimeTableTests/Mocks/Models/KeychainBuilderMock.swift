//
//  KeychainBuilderMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 03/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class KeychainBuilderMock {
    
    // MARK: - KeychainBuilderType
    var buildReturnValue = KeychainAccessMock()
    private(set) var buildParams: [BuildParams] = []
    struct BuildParams {
        let url: URL?
    }
}

// MARK: - KeychainBuilderType
extension KeychainBuilderMock: KeychainBuilderType {
    func build(forURL url: URL?) -> KeychainAccessType {
        self.buildParams.append(BuildParams(url: url))
        return self.buildReturnValue
    }
}
