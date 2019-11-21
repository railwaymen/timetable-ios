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
    private var apiClientMock: ApiClientMock!
    private var coreDataStackUserMock: CoreDataStackMock!
    private var accessServiceMock: AccessServiceUserIDType!
    private var contentProvider: LoginContentProvider!
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        self.apiClientMock = ApiClientMock()
        self.coreDataStackUserMock = CoreDataStackMock()
        self.accessServiceMock = AccessServiceMock()
        self.contentProvider = LoginContentProvider(apiClient: self.apiClientMock,
                                                    coreDataStack: self.coreDataStackUserMock,
                                                    accessService: self.accessServiceMock)
        super.setUp()
        do {
            self.memoryContext = try self.createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testLoginApiClientReturnsAnError() {
        //Arrange
        var expectedError: Error?
        let loginCredentials = LoginCredentials(email: "user@exmaple.com", password: "password")
        //Act
        self.contentProvider.login(with: loginCredentials, fetchCompletion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }, saveCompletion: { _ in })
        self.apiClientMock.signInParams.last?.completion(.failure(ApiClientError(type: .invalidParameters)))
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
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        self.contentProvider.login(with: loginCredentials, fetchCompletion: { _ in
        }, saveCompletion: { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        })
        self.apiClientMock.signInParams.last?.completion(.success(sessionReponse))
        self.coreDataStackUserMock.saveParams.last?.completion(.failure(CoreDataStack.Error.storageItemNotFound))
        //Assert
        switch expectedError as? CoreDataStack.Error {
        case .storageItemNotFound?: break
        default: XCTFail()
        }
    }
    
    func testLoginTransactionDeleteAllCalled() throws {
        //Arrange
        let loginCredentials = LoginCredentials(email: "user@exmaple.com", password: "password")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        let user = UserEntity(context: self.memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        let synchronousDataTransactionMock = AsynchronousDataTransactionMock()
        synchronousDataTransactionMock.createReturnValue = user
        //Act
        self.contentProvider.login(with: loginCredentials, fetchCompletion: { _ in
        }, saveCompletion: { result in
            switch result {
            case .success: break
            case .failure: XCTFail()
            }
        })
        self.apiClientMock.signInParams.last?.completion(.success(sessionReponse))
        _ = self.coreDataStackUserMock.saveParams.last?.translation(synchronousDataTransactionMock)
        self.coreDataStackUserMock.saveParams.last?.completion(.success(user))
        //Assert
        XCTAssertEqual(synchronousDataTransactionMock.deleteAllParams.count, 1)
    }
    
    func testLoginSucceed() throws {
        //Arrange
        var fetchSuccessCalled = false
        var saveSuccessCalled = false
        let loginCredentials = LoginCredentials(email: "user@exmaple.com", password: "password")
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        let user = UserEntity(context: self.memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        let asynchronousDataTransactionMock = AsynchronousDataTransactionMock()
        asynchronousDataTransactionMock.createReturnValue = user
        //Act
        self.contentProvider.login(with: loginCredentials, fetchCompletion: { result in
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
        self.apiClientMock.signInParams.last?.completion(.success(sessionReponse))
        _ = self.coreDataStackUserMock.saveParams.last?.translation(asynchronousDataTransactionMock)
        self.coreDataStackUserMock.saveParams.last?.completion(.success(user))
        //Assert
        XCTAssertTrue(fetchSuccessCalled)
        XCTAssertTrue(saveSuccessCalled)
    }
}