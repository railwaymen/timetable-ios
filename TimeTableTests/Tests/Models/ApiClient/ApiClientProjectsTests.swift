//
//  ApiClientProjectsTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientProjectsTests: XCTestCase {
    private var restler: RestlerMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
    }
}

// MARK: - fetchAllProjects(completion:)
extension ApiClientProjectsTests {
    func testFetchAllProjects_successCompletion() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: ProjectRecordJSONResource.projectsRecordsResponse)
        let decoder = try self.decoder.decode([ProjectRecordDecoder].self, from: data)
        var completionResult: Result<[ProjectRecordDecoder], Error>?
        //Act
        sut.fetchAllProjects { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: [ProjectRecordDecoder].self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }

    func testFetchAllProjects_failureCompletion() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch projects failed")
        var completionResult: Result<[ProjectRecordDecoder], Error>?
        //Act
        sut.fetchAllProjects { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: [ProjectRecordDecoder].self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - fetchSimpleListOfProjects(completion:)
extension ApiClientProjectsTests {
    func testFetchSimpleListOfProjects_successCompletion() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let decoder = try self.decoder.decode([SimpleProjectRecordDecoder].self, from: data)
        var completionResult: Result<[SimpleProjectRecordDecoder], Error>?
        //Act
        sut.fetchSimpleListOfProjects { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: [SimpleProjectRecordDecoder].self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }

    func testFetchSimpleListOfProjects_failureCompletion() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch projects failed")
        var completionResult: Result<[SimpleProjectRecordDecoder], Error>?
        //Act
        sut.fetchSimpleListOfProjects { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: [SimpleProjectRecordDecoder].self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - fetchTags(completion:)
extension ApiClientProjectsTests {
    func testFetchTags_makesGetRequestToProperEndpoint() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Result<ProjectTagsDecoder, Error>?
        //Act
        sut.fetchTags { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.restler.getParams.count, 1)
        XCTAssertEqual(self.restler.getParams.last?.endpoint as? Endpoint, Endpoint.tags)
    }
    
    func testFetchTags_successCompletion() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: ProjectTagJSONResource.projectTagsResponse)
        let decoder = try self.decoder.decode(ProjectTagsDecoder.self, from: data)
        var completionResult: Result<ProjectTagsDecoder, Error>?
        //Act
        sut.fetchTags { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: ProjectTagsDecoder.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }
    
    func testFetchTags_failureCompletion() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch projects failed")
        var completionResult: Result<ProjectTagsDecoder, Error>?
        //Act
        sut.fetchTags { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: ProjectTagsDecoder.self, result: .failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
}

// MARK: - Private
extension ApiClientProjectsTests {
    private func buildSUT() -> ApiClientProjectsType {
        return ApiClient(restler: self.restler)
    }
}
