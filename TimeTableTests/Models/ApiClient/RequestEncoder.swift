//
//  RequestEncoder.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class RequestEncoderTests: XCTestCase {

    private var encoderMock: JSONEncoderMock!
    private var jsonSerializationMock: JSONSerializationMock!
    
    override func setUp() {
        encoderMock = JSONEncoderMock()
        jsonSerializationMock = JSONSerializationMock()
        super.setUp()
    }

    func testEncodeWhileWhileErrorNotOccured() throws {
        //Arrange
        let requestEncoder = RequestEncoder(encoder: encoderMock, serialization: jsonSerializationMock)
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        //Act
        let encodedWrapper = try requestEncoder.encode(wrapper: wrapper)
        let dictionary = try (try JSONSerialization.jsonObject(with: encodedWrapper, options: .allowFragments) as? [AnyHashable: Any]).unwrap()
        //Assert
        XCTAssertEqual(dictionary["email"] as? String, wrapper.email)
        XCTAssertEqual(dictionary["password"] as? String, wrapper.password)
    }
    
    func testEncodeWhileErrorOccured() {
        //Arrange
        let requestEncoder = RequestEncoder(encoder: encoderMock, serialization: jsonSerializationMock)
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        encoderMock.isThrowingError = true
        //Act
        do {
            _ = try requestEncoder.encode(wrapper: wrapper)
        } catch {
            //Assert
            let expectedError = error as? TestError
            XCTAssertEqual(expectedError, TestError(message: "encode error"))
        }
    }
    
    func testEncodeToDictionaryThrowAnErrorWhileEncodingTheWrapper() {
        //Arrange
        let requestEncoder = RequestEncoder(encoder: encoderMock, serialization: jsonSerializationMock)
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        encoderMock.isThrowingError = true
        //Act
        do {
            _ = try requestEncoder.encodeToDictionary(wrapper: wrapper)
        } catch {
            //Assert
            let expectedError = error as? TestError
            XCTAssertEqual(expectedError, TestError(message: "encode error"))
        }
    }
    
    func testEncodeToDictioanryThrowAnErrorWhileSerializingJSONObject() {
        //Arrange
        let requestEncoder = RequestEncoder(encoder: encoderMock, serialization: jsonSerializationMock)
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        jsonSerializationMock.isThrowingError = true
        //Act
        do {
            _ = try requestEncoder.encodeToDictionary(wrapper: wrapper)
        } catch {
            //Assert
            let expectedError = error as? TestError
            XCTAssertEqual(expectedError, TestError(message: "jsonObject error"))
        }
    }
    
    func testEncodeToDictioanryThrowAnErrorWhileSerializedObjectIsNotDictionary() {
        //Arrange
        let requestEncoder = RequestEncoder(encoder: encoderMock, serialization: jsonSerializationMock)
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        jsonSerializationMock.customObject = "This is not a dictionary"
        //Act
        do {
            _ = try requestEncoder.encodeToDictionary(wrapper: wrapper)
        } catch {
            //Assert
            switch (error as? ApiClientError)?.type {
            case .invalidParameters?: break
            default: XCTFail()
            }
        }
    }
}
