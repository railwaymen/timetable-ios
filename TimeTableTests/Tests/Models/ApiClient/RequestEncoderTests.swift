//
//  RequestEncoderTests.swift
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
        super.setUp()
        self.encoderMock = JSONEncoderMock()
        self.jsonSerializationMock = JSONSerializationMock()
    }

    func testEncodeWhileWhileErrorNotOccured() throws {
        //Arrange
        let sut = self.buildSUT()
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        //Act
        let encodedWrapper = try sut.encode(wrapper: wrapper)
        //Assert
        let dictionary = try XCTUnwrap(try JSONSerialization.jsonObject(with: encodedWrapper, options: .allowFragments) as? [AnyHashable: Any])
        XCTAssertEqual(dictionary["email"] as? String, wrapper.email)
        XCTAssertEqual(dictionary["password"] as? String, wrapper.password)
    }
    
    func testEncodeWhileErrorOccured() {
        //Arrange
        let sut = self.buildSUT()
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        self.encoderMock.shouldThrowError = true
        //Act
        do {
            _ = try sut.encode(wrapper: wrapper)
        } catch {
            //Assert
            let expectedError = error as? TestError
            XCTAssertEqual(expectedError, TestError(message: "encode error"))
        }
    }
    
    func testEncodeToDictionaryThrowAnErrorWhileEncodingTheWrapper() {
        //Arrange
        let sut = self.buildSUT()
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        self.encoderMock.shouldThrowError = true
        //Act
        do {
            _ = try sut.encodeToDictionary(wrapper: wrapper)
        } catch {
            //Assert
            let expectedError = error as? TestError
            XCTAssertEqual(expectedError, TestError(message: "encode error"))
        }
    }
    
    func testEncodeToDictioanryThrowAnErrorWhileSerializingJSONObject() {
        //Arrange
        let sut = self.buildSUT()
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        let thrownError = TestError(message: "Test")
        self.jsonSerializationMock.jsonObjectThrowError = thrownError
        //Act
        do {
            _ = try sut.encodeToDictionary(wrapper: wrapper)
        } catch {
            //Assert
            let expectedError = error as? TestError
            XCTAssertEqual(expectedError, thrownError)
        }
    }
    
    func testEncodeToDictioanryThrowAnErrorWhileSerializedObjectIsNotDictionary() {
        //Arrange
        let sut = self.buildSUT()
        let wrapper = LoginCredentials(email: "john@example.com", password: "password")
        self.jsonSerializationMock.jsonObjectReturnValue = "This is not a dictionary"
        //Act
        do {
            _ = try sut.encodeToDictionary(wrapper: wrapper)
        } catch {
            //Assert
            switch (error as? ApiClientError)?.type {
            case .invalidParameters?: break
            default: XCTFail()
            }
        }
    }
}

// MARK: - Private
extension RequestEncoderTests {
    private func buildSUT() -> RequestEncoder {
        return RequestEncoder(
            encoder: self.encoderMock,
            serialization: self.jsonSerializationMock)
    }
}
