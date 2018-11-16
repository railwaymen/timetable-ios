//
//  UserEntitySessionDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 13/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import CoreStore
@testable import TimeTable

class UserEntitySessionDecoderTests: XCTestCase {
    
    private var memoryContext: NSManagedObjectContext!
    private var asynchronousDataTransactionMock: AsynchronousDataTransactionMock!
    
    private enum SessionResponse: String, JSONFileResource {
        case signInResponse
    }
    
    private lazy var decoder = JSONDecoder()
    
    override func setUp() {
        asynchronousDataTransactionMock = AsynchronousDataTransactionMock()
        super.setUp()
        do {
            memoryContext = try createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testCreateUser() throws {
        //Arrange
        let data = try self.json(from: SessionResponse.signInResponse)
        let sessionReponse = try decoder.decode(SessionDecoder.self, from: data)
        let user = UserEntity(context: memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        asynchronousDataTransactionMock.user = user
        //Act
        let createdUser = UserEntity.createUser(from: sessionReponse, transaction: asynchronousDataTransactionMock)
        //Assert
        XCTAssertEqual(Int(createdUser.identifier), sessionReponse.identifier)
        XCTAssertEqual(createdUser.firstName, sessionReponse.firstName)
        XCTAssertEqual(createdUser.lastName, sessionReponse.lastName)
        XCTAssertEqual(createdUser.token, sessionReponse.token)
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
