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
            let expecdedError = error as? TestError
            XCTAssertEqual(expecdedError, TestError(messsage: "encode error"))
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
            let expecdedError = error as? TestError
            XCTAssertEqual(expecdedError, TestError(messsage: "encode error"))
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
            let expecdedError = error as? TestError
            XCTAssertEqual(expecdedError, TestError(messsage: "jsonObject error"))
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
            switch error as? ApiClientError {
            case .invalidParameters?: break
            default: XCTFail()
            }
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

private class JSONSerializationMock: JSONSerializationType {
    var isThrowingError = false
    var customObject: Any?
    
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any {
        if isThrowingError {
            throw TestError(messsage: "jsonObject error")
        } else if let object = customObject {
            return object
        } else {
            return try JSONSerialization.jsonObject(with: data, options: opt)
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
