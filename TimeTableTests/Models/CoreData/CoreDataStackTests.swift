//
//  CoreDataStackTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import CoreStore
@testable import TimeTable

class CoreDataStackTests: XCTestCase {
    
    private var memoryContext: NSManagedObjectContext!
    private var dataStackMock: DataStackMock!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        dataStackMock = DataStackMock()
        super.setUp()
        do {
            memoryContext = try createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testInitializationThrowsAnError() {
        //Arrange
        let testError = TestError(message: "error")
        //Act
        do {
            _ = try CoreDataStack { (_, _) -> DataStackType in throw testError }
        } catch {
            //Assert
            XCTAssertEqual(try (error as? TestError).unwrap(), testError)
        }
    }
    
    func testInitializationSucceed() {
        //Act
        do {
            //Assert
            _ = try CoreDataStack { (_, _) -> DataStackType in return dataStackMock }
        } catch {
            XCTFail()
        }
    }
    
    func testInitializationBuildStackParametes() throws {
        //Act
        _ = try CoreDataStack { (xcodeModelName, fileName) -> DataStackType in
            //Assert
            XCTAssertEqual(xcodeModelName, "TimeTable")
            XCTAssertEqual(fileName, "TimeTable.sqlite")
            return dataStackMock
        }
    }
    
    func testFetchUserForIdentifierFailsWhileWasNotSaveToTheStore() throws {
        //Arrange
        var expectedError: Error?
        let stack = try CoreDataStack { (_, _) -> DataStackType in return dataStackMock }
        //Act
        stack.fetchUser(forIdentifier: 1) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        //Assert
        XCTAssertNotNil(expectedError)
    }
    
    func testFetchUserForIdentifierReturnsTheUser() throws {
        //Arrange
        var expectedEntity: UserEntity?
        let stack = try CoreDataStack { (_, _) -> DataStackType in return dataStackMock }
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        dataStackMock.user = user
        //Act
        stack.fetchUser(forIdentifier: 1) { (result: Result<UserEntity>) in
            switch result {
            case .success(let entity):
                expectedEntity = entity
            case .failure:
                XCTFail()
            }
        }
        //Assert
        XCTAssertEqual(expectedEntity, user)
    }
    
    func testSaveUserDecoderFinishWithError() throws {
        //Arrange
        var expecetdError: Error?
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        let stack = try CoreDataStack { (_, _) -> DataStackType in return dataStackMock }
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        //Act
        stack.save(userDecoder: sessionReponse, coreDataTypeTranslation: { (_) in
            return user
        }) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expecetdError = error
            }
        }
        dataStackMock.performFailure?(CoreStoreError.unknown)
        //Assert
        switch expecetdError as? CoreStoreError {
        case .unknown?: break
        default: XCTFail()
        }
    }
    
    func testSaveUserDecoderSucceedReturnsUserEntity() throws {
        //Arrange
        var expectedEntity: UserEntity?
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        let stack = try CoreDataStack { (_, _) -> DataStackType in return dataStackMock }
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        //Act
        stack.save(userDecoder: sessionReponse, coreDataTypeTranslation: { (_) in
            return user
        }) { result in
            switch result {
            case .success(let entity):
                expectedEntity = entity
            case .failure:
                XCTFail()
            }
        }
        dataStackMock.performSuccess?(user)
        //Assert
        XCTAssertEqual(expectedEntity, user)
    }
    
    func testSaveUserDecoderCoreDataTypeTranslationReturnsTransaction() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        let stack = try CoreDataStack { (_, _) -> DataStackType in return dataStackMock }
        let asynchronousDataTransactionMock = AsynchronousDataTransactionMock()
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        asynchronousDataTransactionMock.user = user
        //Act
        stack.save(userDecoder: sessionReponse, coreDataTypeTranslation: { (transaction: AsynchronousDataTransactionType) -> UserEntity in
            //Assert
            return UserEntity.createUser(from: sessionReponse, transaction: transaction)
        }) { (_: (Result<UserEntity>)) in }
        _ = try dataStackMock.performTask?(asynchronousDataTransactionMock)
    }
}
