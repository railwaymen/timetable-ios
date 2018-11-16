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
    private var contentProvider: LoginContentProvider!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        self.apiClientSessionMock = ApiClientSessionMock()
        self.coreDataStackUserMock = CoreDataStackUserMock()
        self.contentProvider = LoginContentProvider(apiClient: apiClientSessionMock, coreDataStack: coreDataStackUserMock)
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
        contentProvider.login(with: loginCredentials) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        apiClientSessionMock.signInCompletion?(.failure(ApiClientError.invalidParameters))
        //Assert
        switch expectedError as? ApiClientError {
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
        contentProvider.login(with: loginCredentials) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
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
        contentProvider.login(with: loginCredentials) { result in
            switch result {
            case .success: break
            case .failure: XCTFail()
            }
        }
        apiClientSessionMock.signInCompletion?(.success(sessionReponse))
        _ = coreDataStackUserMock.saveCoreDataTypeTranslatior?(synchronousDataTransactionMock)
        coreDataStackUserMock.saveUserCompletion?(.success(user))
        //Assert
        XCTAssertTrue(synchronousDataTransactionMock.deleteAllCalled)
    }
    
    func testLoginSucceed() throws {
        //Arrange
        var successCalled = false
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
        contentProvider.login(with: loginCredentials) { result in
            switch result {
            case .success:
                successCalled = true
            case .failure:
                XCTFail()
            }
        }
        apiClientSessionMock.signInCompletion?(.success(sessionReponse))
        _ = coreDataStackUserMock.saveCoreDataTypeTranslatior?(asynchronousDataTransactionMock)
        coreDataStackUserMock.saveUserCompletion?(.success(user))
        //Assert
        XCTAssertTrue(successCalled)
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

private class CoreDataStackUserMock: CoreDataStackUserType {
    
    typealias CDT = UserEntity
    private(set) var fetchUserIdentifier: Int?
    private(set) var fetchUserCompletion: ((Result<UserEntity>) -> Void)?
    private(set) var saveUserDecoder: SessionDecoder?
    private(set) var saveUserCompletion: ((Result<UserEntity>) -> Void)?
    private(set) var saveCoreDataTypeTranslatior: ((AsynchronousDataTransactionType) -> UserEntity)?
    
    func fetchUser(forIdentifier identifier: Int, completion: @escaping (Result<UserEntity>) -> Void) {
        fetchUserIdentifier = identifier
        fetchUserCompletion = completion
    }
    
    func save<CDT>(userDecoder: SessionDecoder,
                   coreDataTypeTranslation: @escaping ((AsynchronousDataTransactionType) -> CDT),
                   completion: @escaping (Result<CDT>) -> Void) {
    
        // swiftlint:disable force_cast
        saveUserDecoder = userDecoder
        saveUserCompletion = { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let entity):
                completion(.success(entity as! CDT))
            }
        }
        saveCoreDataTypeTranslatior = { transaction in
            return coreDataTypeTranslation(transaction) as! UserEntity
        }
        // swiftlint:enable force_cast
    }
}

private class AsynchronousDataTransactionMock: AsynchronousDataTransactionType {
    
    private(set) var deleteAllCalled = false
    private(set) var createCalled = false
    var user: DynamicObject?
    
    func deleteAll<D>(_ from: From<D>, _ deleteClauses: DeleteClause...) -> Int? where D: DynamicObject {
        deleteAllCalled = true
        return nil
    }
    
    func create<D>(_ into: Into<D>) -> D where D: DynamicObject {
        createCalled = true
        // swiftlint:disable force_cast
        return user as! D
        // swiftlint:enable force_cast
    }
}
