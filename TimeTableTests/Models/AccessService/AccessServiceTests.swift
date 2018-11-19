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
    
    override func setUp() {
        userDefaultsMock = UserDefaultsMock()
        keychainAccessMock = KeychainAccessMock()
        encoderMock = JSONEncoderMock()
        decoderMock = JSONDecoderMock()
        accessService = AccessService(userDefaults: userDefaultsMock, keychainAccess: keychainAccessMock,
                                      buildEncoder: { return self.encoderMock }, buildDecoder: { return self.decoderMock })
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
            switch error as? AccessService.Error {
            case .cannotFetchLoginCredentials?: break
            default:
                XCTFail()
            }
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
            switch error as? AccessService.Error {
            case .cannotFetchLoginCredentials?: break
            default:
                XCTFail()
            }
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
}

private class UserDefaultsMock: UserDefaultsType {
    func bool(forKey defaultName: String) -> Bool {
        return false
    }
    
    func removeObject(forKey defaultName: String) {}
    func set(_ value: Any?, forKey defaultName: String) {}
    func set(_ value: Bool, forKey defaultName: String) {}
    
    func string(forKey defaultName: String) -> String? {
        return nil
    }
}

private class KeychainAccessMock: KeychainAccessType {
    var setDataIsThrowingError = false
    var getDataIsThrowingError = false
    var getDataValue: Data?
    
    func get(_ key: String) throws -> String? {
        return nil
    }
    func getData(_ key: String) throws -> Data? {
        if getDataIsThrowingError {
            throw TestError(messsage: "set Data error")
        } else {
            return getDataValue
        }
    }
    func set(_ value: String, key: String) throws {}

    func set(_ value: Data, key: String) throws {
        if setDataIsThrowingError {
            throw TestError(messsage: "set Data error")
        }
    }
}

private class JSONEncoderMock: JSONEncoderType {
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    var isThrowingError = false
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        if isThrowingError {
            throw TestError(messsage: "encode error")
        } else {
            return try encoder.encode(value)
        }
    }
}

private class JSONDecoderMock: JSONDecoderType {
    
    private lazy var decoder: JSONDecoder = JSONDecoder()
    
    var isThrowingError = false
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if isThrowingError {
            throw TestError(messsage: "decode error")
        } else {
            return try decoder.decode(T.self, from: data)
        }
    }
}

private struct TestError: Error {
    let messsage: String
}

extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.messsage == rhs.messsage
    }
}
