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
    
    private var userDefaultsMock: UserDefaultsMock!
    private var keychainAccessMock: KeychainAccessMock!
    private var encoderMock: JSONEncoderMock!
    private var decoderMock: JSONDecoderMock!
    private var accessService: AccessService!
    private var coreDataMock: CoreDataStackMock!
    
    override func setUp() {
        super.setUp()
        self.userDefaultsMock = UserDefaultsMock()
        self.keychainAccessMock = KeychainAccessMock()
        self.coreDataMock = CoreDataStackMock()
        self.encoderMock = JSONEncoderMock()
        self.decoderMock = JSONDecoderMock()
        self.accessService = AccessService(userDefaults: self.userDefaultsMock,
                                           keychainAccess: self.keychainAccessMock,
                                           coreData: self.coreDataMock,
                                           buildEncoder: { return self.encoderMock },
                                           buildDecoder: { return self.decoderMock })
    }
    
    func testSaveUserThrowsAnErrorWhileCredentialsEncodingFails() {
        //Arrange
        let credentails = LoginCredentials(email: "user@example.com", password: "password")
        self.encoderMock.shouldThrowError = true
        //Act
        do {
            try self.accessService.saveUser(credentails: credentails)
        } catch {
            //Assert
            switch error as? AccessService.Error {
            case .cannotSaveLoginCredentials?: break
            default:
                XCTFail()
            }
        }
    }
    
    func testSaveUserThrowsAnErrorWhileKeychainAccessFailsWhileSaving() {
        //Arrange
        let credentails = LoginCredentials(email: "user@example.com", password: "password")
        self.keychainAccessMock.setDataIsThrowingError = true
        //Act
        do {
            try self.accessService.saveUser(credentails: credentails)
        } catch {
            //Assert
            switch error as? AccessService.Error {
            case .cannotSaveLoginCredentials?: break
            default:
                XCTFail()
            }
        }
    }
    
    func testSaveUserSucceed() throws {
        //Arrange
        let credentails = LoginCredentials(email: "user@example.com", password: "password")
        //Act
        //Assert
        try self.accessService.saveUser(credentails: credentails)
    }
    
    func testGetUserCredentialsFailsWhileKeychainAccessThrowsAnError() {
        //Arrange
        self.keychainAccessMock.getDataIsThrowingError = true
        //Act
        do {
            _ = try self.accessService.getUserCredentials()
        } catch {
            //Assert
            XCTAssertEqual(try (error as? TestError).unwrap(), TestError(message: "set Data error"))
        }
    }
    
    func testGetUserCredentialsFailsWhileKeychainAccessReturnsNilValue() {
        //Arrange
        self.keychainAccessMock.getDataValue = nil
        //Act
        do {
            _ = try self.accessService.getUserCredentials()
        } catch {
            //Assert
            switch error as? AccessService.Error {
            case .cannotFetchLoginCredentials?: break
            default:
                XCTFail()
            }
        }
    }

    func testGetUserCredentialsFailsWhileDecoderThrowsAnError() throws {
        //Arrange
        let credentials = LoginCredentials(email: "user@example.com", password: "password")
        let data = try JSONEncoder().encode(credentials)
        self.keychainAccessMock.getDataValue = data
        self.decoderMock.shouldThrowError = true
        //Act
        do {
            _ = try self.accessService.getUserCredentials()
        } catch {
            //Assert
            XCTAssertEqual(try (error as? TestError).unwrap(), TestError(message: "decoder error"))
        }
    }

    func testGetUserCredentialsSucceed() throws {
        //Arrange
        let credentials = LoginCredentials(email: "user@example.com", password: "password")
        let data = try JSONEncoder().encode(credentials)
        self.keychainAccessMock.getDataValue = data
        //Act
        let accessServiceCredentials = try self.accessService.getUserCredentials()
        //Assert
        XCTAssertEqual(accessServiceCredentials, credentials)
    }
    
    func testSaveLastLoggedInUserIdentifier() throws {
        //Arrange
        let identifier = Int64(2)
        //Act
        self.accessService.saveLastLoggedInUserIdentifier(identifier)
        //Assert
        XCTAssertEqual(try (self.userDefaultsMock.setAnyValues.value as? Int64).unwrap(), identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsNilWhileUserDefaultsReturnsNil() {
        //Arrange
        //Act
        let identifier = self.accessService.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertNil(identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsNilWhileUserDefaultsReturnsNotAnInt64() {
        //Arrange
        self.userDefaultsMock.objectForKey = "TEST"
        //Act
        let identifier = self.accessService.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertNil(identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsCorrectValue() {
        //Arrange
        let expectedIdentifier = Int64(3)
        self.userDefaultsMock.objectForKey = expectedIdentifier
        //Act
        let identifier = self.accessService.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertEqual(identifier, expectedIdentifier)
    }
    
    func testRemoveLastLoggedInUserIdentifier() {
        //Arrange
        //Act
        self.accessService.removeLastLoggedInUserIdentifier()
        //Assert
        XCTAssertTrue(self.userDefaultsMock.removeObjectValues.called)
    }
}
