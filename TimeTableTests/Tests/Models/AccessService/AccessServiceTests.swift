//
//  AccessServiceTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 19/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class AccessServiceTests: XCTestCase {
    private var keychainAccessMock: KeychainAccessMock!
    private var encoderMock: JSONEncoderMock!
    private var decoderMock: JSONDecoderMock!
    
    override func setUp() {
        super.setUp()
        self.keychainAccessMock = KeychainAccessMock()
        self.encoderMock = JSONEncoderMock()
        self.decoderMock = JSONDecoderMock()
    }
}

// MARK: - Private
extension AccessServiceTests {
    
}
