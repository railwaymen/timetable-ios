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
        userDefaultsMock = UserDefaultsMock()
        keychainAccessMock = KeychainAccessMock()
        coreDataMock = CoreDataStackMock()
        encoderMock = JSONEncoderMock()
        decoderMock = JSONDecoderMock()
        accessService = AccessService(userDefaults: userDefaultsMock,
                                      keychainAccess: keychainAccessMock,
                                      coreData: coreDataMock,
                                      buildEncoder: { return self.encoderMock },
                                      buildDecoder: { return self.decoderMock })
        super.setUp()
    }
    
    func testSaveUserThrowsAnErrorWhileCredentialsEncodingFails() {
        //Arrange
        let credentails = LoginCredentials(email: "user@example.com", password: "password")
        encoderMock.isThrowingError = true
        //Act
        do {
            try accessService.saveUser(credentails: credentails)
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
        keychainAccessMock.setDataIsThrowingError = true
        //Act
        do {
            try accessService.saveUser(credentails: credentails)
        } catch {
            //Assert
            switch error as? AccessService.Error {
            case .cannotSaveLoginCredentials?: break
            default:
                XCTFail()
            }
        }
    }
    
    func testSaveUserSucceed() {
        //Arrange
        let credentails = LoginCredentials(email: "user@example.com", password: "password")
        //Act
        do {
            //Assert
            try accessService.saveUser(credentails: credentails)
        } catch {
            XCTFail()
        }
    }
    
    func testGetUserCredentialsFailsWhileKeychainAccessThrowsAnError() {
        //Arrange
        keychainAccessMock.getDataIsThrowingError = true
        //Act
        do {
            _ = try accessService.getUserCredentials()
        } catch {
            //Assert
            XCTAssertEqual(try (error as? TestError).unwrap(), TestError(message: "set Data error"))
        }
    }
    
    func testGetUserCredentialsFailsWhileKeychainAccessReturnsNilValue() {
        //Arrange
        keychainAccessMock.getDataValue = nil
        //Act
        do {
            _ = try accessService.getUserCredentials()
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
        keychainAccessMock.getDataValue = data
        decoderMock.isThrowingError = true
        //Act
        do {
            _ = try accessService.getUserCredentials()
        } catch {
            //Assert
            XCTAssertEqual(try (error as? TestError).unwrap(), TestError(message: "decoder error"))
        }
    }

    func testGetUserCredentialsSucceed() throws {
        //Arrange
        let credentials = LoginCredentials(email: "user@example.com", password: "password")
        let data = try JSONEncoder().encode(credentials)
        keychainAccessMock.getDataValue = data
        //Act
        do {
            let accessServiceCredentials = try accessService.getUserCredentials()
            //Assert
            XCTAssertEqual(accessServiceCredentials, credentials)
        } catch {
            XCTFail()
        }
    }
    
    func testSaveLastLoggedInUserIdentifier() throws {
        //Arrange
        let identifier = Int64(2)
        //Act
        accessService.saveLastLoggedInUserIdentifier(identifier)
        //Assert
        XCTAssertEqual(try (userDefaultsMock.setAnyValues.value as? Int64).unwrap(), identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsNilWhileUserDefaultsReturnsNil() {
        //Arrange
        //Act
        let identifier = accessService.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertNil(identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsNilWhileUserDefaultsReturnsNotAnInt64() {
        //Arrange
        userDefaultsMock.objectForKey = "TEST"
        //Act
        let identifier = accessService.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertNil(identifier)
    }
    
    func testGetLastLoggedInUserIdentifierReturnsCorrectValue() {
        //Arrange
        let expectedIdentifier = Int64(3)
        userDefaultsMock.objectForKey = expectedIdentifier
        //Act
        let identifier = accessService.getLastLoggedInUserIdentifier()
        //Assert
        XCTAssertEqual(identifier, expectedIdentifier)
    }
    
    func testRemoveLastLoggedInUserIdentifier() {
        //Arrange
        //Act
        accessService.removeLastLoggedInUserIdentifier()
        //Assert
        XCTAssertTrue(userDefaultsMock.removeObjectValues.called)
    }
}
