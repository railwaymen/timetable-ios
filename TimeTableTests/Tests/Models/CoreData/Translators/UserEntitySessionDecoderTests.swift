//
//  UserEntitySessionDecoderTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 13/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
import CoreData
@testable import TimeTable

class UserEntitySessionDecoderTests: XCTestCase {
    private var memoryContext: NSManagedObjectContext!
    private var asynchronousDataTransactionMock: AsynchronousDataTransactionMock!
        
    override func setUp() {
        super.setUp()
        self.asynchronousDataTransactionMock = AsynchronousDataTransactionMock()
        do {
            self.memoryContext = try self.createInMemoryStorage()
        } catch {
            XCTFail()
        }
    }
    
    func testCreateUser() throws {
        //Arrange
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        let user = UserEntity(context: self.memoryContext)
        user.identifier = 1
        user.token = "token_abcd"
        user.firstName = "John"
        user.lastName = "Little"
        self.asynchronousDataTransactionMock.createReturnValue = user
        //Act
        let sut = UserEntity.createUser(from: sessionReponse, transaction: self.asynchronousDataTransactionMock)
        //Assert
        XCTAssertEqual(Int(sut.identifier), sessionReponse.identifier)
        XCTAssertEqual(sut.firstName, sessionReponse.firstName)
        XCTAssertEqual(sut.lastName, sessionReponse.lastName)
        XCTAssertEqual(sut.token, sessionReponse.token)
    }
}
