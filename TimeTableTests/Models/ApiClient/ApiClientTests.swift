//
//  ApiClientTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientTests: XCTestCase {
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    
    private enum SessionResponse: String, JSONFileResource {
        case singInResponse
    }
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        super.setUp()
    }

    // MARK: - ApiClientNetworkingType
    func testPostRetunrsAnErrorWhileGivenWrapperCannotBeEncodedToDictionary() {
        //Arrange
        var expectedError: Error?
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        requestEncoderMock.isEncodeToDictionaryThrowingError = true
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        switch expectedError as? ApiClientError {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }
    
    func testPostReturnsAnErrorWhileNetworkRequestFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(messsage: "500 - server internal error")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.shortPostCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testPostRetrunsCorrectDecodableObject() throws {
        //Arrange
        var expectedDecoder: Decodable?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try self.json(from: SessionResponse.singInResponse)
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success(let decoder):
                expectedDecoder = decoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.shortPostCompletion?(.success(data))
        //Assert
        let decoder = try (expectedDecoder as? SessionDecoder).unwrap()
        XCTAssertEqual(decoder.identifier, 1)
        XCTAssertEqual(decoder.firstName, "Admin")
        XCTAssertEqual(decoder.lastName, "Little")
        XCTAssertFalse(decoder.isLeader)
        XCTAssertTrue(decoder.admin)
        XCTAssertFalse(decoder.manager)
        XCTAssertEqual(decoder.token, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJiMDhmODZhZi0zNWRhLTQ4ZjIt")
    }
    
    func testPostReturnsAnErrorWhileResponseJSONIsInvalid() throws {
        //Arrange
        var expectedError: Error?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let data = try JSONSerialization.data(withJSONObject: ["test": "test"], options: .prettyPrinted)
        let apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.post(Endpoints.signIn, parameters: parameters) { (result: TimeTable.Result<SessionDecoder>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
                
            }
        }
        networkingMock.shortPostCompletion?(.success(data))
        //Assert
        switch expectedError as? ApiClientError {
        case .invalidResponse?: break
        default: XCTFail()
        }
    }
    
    // MARK: - ApiClientSessionType
    func testSignInSucced() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.singInResponse)
        let decoder = try JSONDecoder().decode(SessionDecoder.self, from: data)
        var expecdedSessionDecoder: SessionDecoder?
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient: ApiClientSessionType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.signIn(with: parameters) { result in
            switch result {
            case .success(let sessionDecoder):
                expecdedSessionDecoder = sessionDecoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.shortPostCompletion?(.success(data))
        //Assert
        XCTAssertEqual(try expecdedSessionDecoder.unwrap(), decoder)
    }
    
    func testSignInFailed() throws {
        //Arrange
        var expecdedError: Error?
        let error = TestError(messsage: "sign in failed")
        let parameters = LoginCredentials(email: "user1@example.com", password: "password")
        let apiClient: ApiClientSessionType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.signIn(with: parameters) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expecdedError = error
            }
        }
        networkingMock.shortPostCompletion?(.failure(error))
        //Assert
        let testError = try (expecdedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}

private class NetworkingMock: NetworkingType {
    private(set) var shortPostValues: (path: String, parametres: Any?)?
    private(set) var shortPostCompletion: ((TimeTable.Result<Data>) -> Void)?
    
    var headerFields: [String: String]?
    
    func post(_ path: String, parameters: Any?, completion: @escaping (_ result: TimeTable.Result<Data>) -> Void) -> String {
        shortPostValues = (path, parameters)
        shortPostCompletion = completion
        return ""
    }
}

private class RequestEncoderMock: RequestEncoderType {
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private(set) var encodeWrapper: Encodable?
    var isEncodeThrowingError = false

    func encode<T>(wrapper: T) throws -> Data where T: Encodable {
        self.encodeWrapper = wrapper
        if isEncodeThrowingError {
            throw TestError(messsage: "encode error")
        } else {
            return try encoder.encode(wrapper)
        }
    }
    
    private(set) var encodeToDictionaryWrapper: Encodable?
    var isEncodeToDictionaryThrowingError = false
    
    func encodeToDictionary<T>(wrapper: T) throws -> [String: Any] where T: Encodable {
        self.encodeToDictionaryWrapper = wrapper
        if isEncodeToDictionaryThrowingError {
            throw TestError(messsage: "encode to dictionary error")
        } else {
            let data = try encoder.encode(wrapper)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw TestError(messsage: "JSONSerialization.jsonObject error")
            }
            return json
        }
    }
}

private class JSONDecoderMock: JSONDecoderType {
    
    private lazy var decoder = JSONDecoder()
    
    var isDecodeThrowingError = false
    private(set) var decodeType: Decodable.Type?
    private(set) var decodeData: Data?
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        decodeType = type
        decodeData = data
        if isDecodeThrowingError {
            throw TestError(messsage: "decoder error")
        } else {
            return try decoder.decode(type, from: data)
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
