//
//  LoginContentProviderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import CoreData
import CoreStore
@testable import TimeTable

class LoginContentProviderTests: XCTestCase {
    
    private var memoryContext: NSManagedObjectContext!
    private var apiClientSessionMock: ApiClientSessionMock!
    private var coreDataStackUserMock: CoreDataStackUserMock!
    private var accessServiceMock: AccessServiceUserIDType!
    private var contentProvider: LoginContentProvider!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        self.apiClientSessionMock = ApiClientSessionMock()
        self.coreDataStackUserMock = CoreDataStackUserMock()
        self.accessServiceMock = AccessServiceMock()
        self.contentProvider = LoginContentProvider(apiClient: apiClientSessionMock, coreDataStack: coreDataStackUserMock, accessService: accessServiceMock)
        super.setUp()
        do {
            memoryContext = try createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testLoginApiClientReturnsAnError() {
        //Arrange
        var expectedError: Error?
        let loginCredentials = LoginCredentials(email: "user@exmaple.com", password: "password")
        //Act
        contentProvider.login(with: loginCredentials, fetchCompletion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }, saveCompletion: { _ in })
        apiClientSessionMock.signInCompletion?(.failure(ApiClientError(type: .invalidParameters)))
        //Assert
        switch (expectedError as? ApiClientError)?.type {
        case .invalidParameters?: break
        default: XCTFail()
        }
    }
    
    func testLoginCoreDataStackReturnAnError() throws {
        //Arrange
        var expectedError: Error?
        let loginCredentials = LoginCredentials(email: "user@exmaple.com", password: "password")
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        //Act
        contentProvider.login(with: loginCredentials, fetchCompletion: { _ in
        }, saveCompletion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        })
        apiClientSessionMock.signInCompletion?(.success(sessionReponse))
        coreDataStackUserMock.saveUserCompletion?(.failure(CoreDataStack.Error.storageItemNotFound))
        //Assert
        switch expectedError as? CoreDataStack.Error {
        case .storageItemNotFound?: break
        default: XCTFail()
        }
    }
    
    func testLoginTransactionDeleteAllCalled() throws {
        //Arrange
        let loginCredentials = LoginCredentials(email: "user@exmaple.com", password: "password")
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        let synchronousDataTransactionMock = AsynchronousDataTransactionMock()
        synchronousDataTransactionMock.user = user
        //Act
        contentProvider.login(with: loginCredentials, fetchCompletion: { _ in
        }, saveCompletion: { result in
            switch result {
            case .success: break
            case .failure: XCTFail()
            }
        })
        apiClientSessionMock.signInCompletion?(.success(sessionReponse))
        _ = coreDataStackUserMock.saveCoreDataTypeTranslatior?(synchronousDataTransactionMock)
        coreDataStackUserMock.saveUserCompletion?(.success(user))
        //Assert
        XCTAssertTrue(synchronousDataTransactionMock.deleteAllCalled)
    }
    
    func testLoginSucceed() throws {
        //Arrange
        var fetchSuccessCalled = false
        var saveSuccessCalled = false
        let loginCredentials = LoginCredentials(email: "user@exmaple.com", password: "password")
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        let asynchronousDataTransactionMock = AsynchronousDataTransactionMock()
        asynchronousDataTransactionMock.user = user
        //Act
        contentProvider.login(with: loginCredentials, fetchCompletion: { result in
            switch result {
            case .success:
                fetchSuccessCalled = true
            case .failure:
                XCTFail()
            }
        }, saveCompletion: { result in
            switch result {
            case .success:
                saveSuccessCalled = true
            case .failure:
                XCTFail()
            }
        })
        apiClientSessionMock.signInCompletion?(.success(sessionReponse))
        _ = coreDataStackUserMock.saveCoreDataTypeTranslatior?(asynchronousDataTransactionMock)
        coreDataStackUserMock.saveUserCompletion?(.success(user))
        //Assert
        XCTAssertTrue(fetchSuccessCalled)
        XCTAssertTrue(saveSuccessCalled)
    }
}

private class ApiClientSessionMock: ApiClientSessionType {
    private(set) var signInCredentials: LoginCredentials?
    private(set) var signInCompletion: ((Result<SessionDecoder>) -> Void)?
    
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        signInCredentials = credentials
        signInCompletion = completion
    }
}
