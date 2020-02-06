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
    private var userDefaults: UserDefaults!
    private var keychainAccessMock: KeychainAccessMock!
    private var encoderMock: JSONEncoderMock!
    private var decoderMock: JSONDecoderMock!
    private var coreDataMock: CoreDataStackMock!
    
    override func setUp() {
        super.setUp()
        self.userDefaults = UserDefaults()
        self.keychainAccessMock = KeychainAccessMock()
        self.coreDataMock = CoreDataStackMock()
        self.encoderMock = JSONEncoderMock()
        self.decoderMock = JSONDecoderMock()
    }
    
    override func tearDown() {
        self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        super.tearDown()
    }
    
    func testSaveLastLoggedInUserIdentifier() throws {
        //Arrange
        let sut = self.buildSUT()
        let identifier = Int64(2)
        //Act
        sut.saveLastLoggedInUserIdentifier(identifier)
        //Assert
        XCTAssertEqual(self.userDefaults.value(forKey: "key.time_table.last_logged_user.id.key") as? Int64, identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsNilWhileUserDefaultsReturnsNil() {
        //Act
        let sut = self.buildSUT()
        let identifier = sut.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertNil(identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsNilWhileUserDefaultsReturnsNotAnInt64() {
        //Arrange
        let sut = self.buildSUT()
        self.userDefaults.set("TEST", forKey: "key.time_table.last_logged_user.id.key")
        //Act
        let identifier = sut.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertNil(identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsCorrectValue() {
        //Arrange
        let sut = self.buildSUT()
        let expectedIdentifier = Int64(3)
        self.userDefaults.set(expectedIdentifier, forKey: "key.time_table.last_logged_user.id.key")
        //Act
        let identifier = sut.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertEqual(identifier, expectedIdentifier)
    }
    
    func testRemoveLastLoggedInUserIdentifier() {
        //Arrange
        let sut = self.buildSUT()
        let key = "key.time_table.last_logged_user.id.key"
        self.userDefaults.set("test", forKey: key)
        //Act
        sut.removeLastLoggedInUserIdentifier()
        //Assert
        XCTAssertNil(self.userDefaults.object(forKey: key))
    }
}

// MARK: - Private
extension AccessServiceTests {
    private func buildSUT() -> AccessService {
        return AccessService(
            userDefaults: self.userDefaults,
            keychainAccess: self.keychainAccessMock,
            coreData: self.coreDataMock,
            encoder: self.encoderMock,
            decoder: self.decoderMock)
    }
}
