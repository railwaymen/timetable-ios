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

// MARK: - fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder], Error>) -> Void))
extension ApiClientProjectsTests {
    func testFetchAllProjectsSucceed() throws {
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

    func testFetchAllProjectsFailed() throws {
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

// MARK: - fetchSimpleListOfProjects(completion: @escaping ((Result<SimpleProjectDecoder, Error>) -> Void))
extension ApiClientProjectsTests {
    func testFetchSimpleProjectArrayResponseSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let decoder = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        var completionResult: Result<SimpleProjectDecoder, Error>?
        //Act
        sut.fetchSimpleListOfProjects { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: SimpleProjectDecoder.self, result: .success(decoder))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), decoder)
    }

    func testFetchSimpleProjectArrayResponseFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = TestError(message: "fetch projects failed")
        var completionResult: Result<SimpleProjectDecoder, Error>?
        //Act
        sut.fetchSimpleListOfProjects { result in
            completionResult = result
        }
        try self.restler.getReturnValue.callCompletion(type: SimpleProjectDecoder.self, result: .failure(error))
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
