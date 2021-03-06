//
//  CustomJSONSerializationTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class CustomJSONSerializationTests: XCTestCase {}

// MARK: - jsonObject(with data: Data, options: JSONSerialization.ReadingOptions) throws -> Any
extension CustomJSONSerializationTests {
    func testJsonObject() throws {
        //Arrange
        let sut = CustomJSONSerialization()
        let data = try self.json(from: SessionJSONResource.signInResponse)
        let sessionReponse = try self.decoder.decode(SessionDecoder.self, from: data)
        //Act
        let jsonData = try sut.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
        //Assert
        let json = try XCTUnwrap(jsonData)
        XCTAssertEqual(json["id"] as? Int, sessionReponse.id)
        XCTAssertEqual(json["first_name"] as? String, sessionReponse.firstName)
        XCTAssertEqual(json["last_name"] as? String, sessionReponse.lastName)
        XCTAssertEqual(json["is_leader"] as? Bool, sessionReponse.isLeader)
        XCTAssertEqual(json["admin"] as? Bool, sessionReponse.admin)
        XCTAssertEqual(json["manager"] as? Bool, sessionReponse.manager)
        XCTAssertEqual(json["token"] as? String, sessionReponse.token)
    }
}
