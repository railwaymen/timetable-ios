//
//  LoginCredentialsTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 02/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class LoginCredentialsTests: XCTestCase {

    func testCreatedSessionRequestIsCorrect() throws {
        //Arrange
        let sut = LoginCredentials(email: "user1@example.com", password: "password")
        let sessionRequestSample = try self.json(from: SessionJSONResource.signInRequest)
        let sampleDictionary = try JSONSerialization.jsonObject(with: sessionRequestSample, options: .allowFragments) as? [AnyHashable: Any]
        //Act
        let data = try self.encoder.encode(sut)
        let requestDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        let requestEmail = try (requestDictionary?["email"] as? String).unwrap()
        let sampleEmail = try (sampleDictionary?["email"] as? String).unwrap()
        XCTAssertEqual(requestEmail, sampleEmail)
        let requestPassword = try (requestDictionary?["password"] as? String).unwrap()
        let samplePassword = try (requestDictionary?["password"] as? String).unwrap()
        XCTAssertEqual(requestPassword, samplePassword)
    }
}
