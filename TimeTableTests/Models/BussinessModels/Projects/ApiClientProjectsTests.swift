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
    private var apiClient: ApiClientProjectsType!
    
    private enum ProjectsRecordsResponse: String, JSONFileResource {
        case projectsRecordsResponse
        case simpleProjectArrayResponse
    }
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        self.apiClient = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
        return self.requestEncoderMock
        }) { () -> JSONDecoderType in
            return self.jsonDecoderMock
        }
        super.setUp()
    }
    
    // MARK: - ApiClientSessionType
    func testFetchAllProjectsSucceed() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.projectsRecordsResponse)
        let decoder = try JSONDecoder().decode([ProjectRecordDecoder].self, from: data)
        var expectedProjectsRecordsDecoder: [ProjectRecordDecoder]?
        //Act
        apiClient.fetchAllProjects { result in
            switch result {
            case .success(let projectsRecordsDecoder):
                expectedProjectsRecordsDecoder = projectsRecordsDecoder
            case .failure:
                XCTFail()
            }
        }

        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(expectedProjectsRecordsDecoder?.count, decoder.count)
    }
    
    func testFetchAllProjectsFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "fetch projects failed")
        //Act
        apiClient.fetchAllProjects { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.getCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testFetchSimpleProjectArrayResponseSucceed() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let decoder = try JSONDecoder().decode(SimpleProjectDecoder.self, from: data)
        var expectedSimpleProjectDecoder: SimpleProjectDecoder?
        //Act
        apiClient.fetchSimpleListOfProjects { result in
            switch result {
            case .success(let simpleProjectDecoder):
                expectedSimpleProjectDecoder = simpleProjectDecoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(expectedSimpleProjectDecoder?.projects.count, decoder.projects.count)
    }
    
    func testFetchSimpleProjectArrayResponseFailed() throws {
        //Arrange
        var expectedError: Error?
        let error = TestError(message: "fetch projects failed")
        //Act
        apiClient.fetchSimpleListOfProjects { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expectedError = error
            }
        }
        networkingMock.getCompletion?(.failure(error))
        //Assert
        let testError = try (expectedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}
