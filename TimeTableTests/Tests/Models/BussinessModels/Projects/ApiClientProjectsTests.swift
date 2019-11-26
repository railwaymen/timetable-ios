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
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    
    override func setUp() {
        super.setUp()
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
    }
    
    // MARK: - ApiClientSessionType
    func testFetchAllProjectsSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: ProjectRecordJSONResource.projectsRecordsResponse)
        let decoder = try self.decoder.decode([ProjectRecordDecoder].self, from: data)
        var expectedProjectsRecordsDecoder: [ProjectRecordDecoder]?
        //Act
        sut.fetchAllProjects { result in
            switch result {
            case .success(let projectsRecordsDecoder):
                expectedProjectsRecordsDecoder = projectsRecordsDecoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.getParams.last?.completion(.success(data))
        //Assert
        XCTAssertEqual(expectedProjectsRecordsDecoder?.count, decoder.count)
    }
    
    func testFetchAllProjectsFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        var expectedError: Error?
        let error = TestError(message: "fetch projects failed")
        //Act
        sut.fetchAllProjects { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.getParams.last?.completion(.failure(error))
        //Assert
        let testError = try XCTUnwrap(expectedError as? TestError)
        XCTAssertEqual(testError, error)
    }
    
    func testFetchSimpleProjectArrayResponseSucceed() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try self.json(from: SimpleProjectJSONResource.simpleProjectArrayResponse)
        let decoder = try self.decoder.decode(SimpleProjectDecoder.self, from: data)
        var expectedSimpleProjectDecoder: SimpleProjectDecoder?
        //Act
        sut.fetchSimpleListOfProjects { result in
            switch result {
            case .success(let simpleProjectDecoder):
                expectedSimpleProjectDecoder = simpleProjectDecoder
            case .failure:
                XCTFail()
            }
        }
        self.networkingMock.getParams.last?.completion(.success(data))
        //Assert
        XCTAssertEqual(expectedSimpleProjectDecoder?.projects.count, decoder.projects.count)
    }
    
    func testFetchSimpleProjectArrayResponseFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        var expectedError: Error?
        let error = TestError(message: "fetch projects failed")
        //Act
        sut.fetchSimpleListOfProjects { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        self.networkingMock.getParams.last?.completion(.failure(error))
        //Assert
        let testError = try XCTUnwrap(expectedError as? TestError)
        XCTAssertEqual(testError, error)
    }
}

// MARK: - Private
extension ApiClientProjectsTests {
    private func buildSUT() -> ApiClientProjectsType {
        return ApiClient(
            networking: self.networkingMock,
            encoder: self.requestEncoderMock,
            decoder: self.jsonDecoderMock)
    }
}
