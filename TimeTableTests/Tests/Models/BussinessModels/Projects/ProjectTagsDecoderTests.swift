//
//  ProjectTagsDecoderTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 20/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectTagsDecoderTests: XCTestCase {}

// MARK: - Decoding
extension ProjectTagsDecoderTests {
    func testDecoding_fullArray() throws {
        //Arrange
        let data = try self.json(from: ProjectTagJSONResource.projectTagsResponse)
        //Act
        let sut = try self.decoder.decode(ProjectTagsDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.tags, [.development, .internalMeeting, .clientCommunication, .research])
    }
    
    func testDecoding_missingTags() throws {
        //Arrange
        let data = try self.json(from: ProjectTagJSONResource.projectTagsMissingResponse)
        //Act
        let sut = try self.decoder.decode(ProjectTagsDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.tags, [.development, .internalMeeting, .research])
    }
    
    func testDecoding_unknownTags() throws {
        //Arrange
        let data = try self.json(from: ProjectTagJSONResource.projectTagsUnknownResponse)
        //Act
        let sut = try self.decoder.decode(ProjectTagsDecoder.self, from: data)
        //Assert
        XCTAssertEqual(sut.tags, [.development, .internalMeeting, .clientCommunication, .research])
    }
}
