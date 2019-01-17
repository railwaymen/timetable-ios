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
    
    private enum ProjectsRecordsResponse: String, JSONFileResource {
        case projectsRecordsResponse
        case simpleProjectArrayResponse
    }
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        super.setUp()
    }
    
    // MARK: - ApiClientSessionType
    func testFetchAllProjectsSucceed() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.projectsRecordsResponse)
        let decoder = try JSONDecoder().decode([ProjectRecordDecoder].self, from: data)
        var expecdedProjectsRecordsDecoder: [ProjectRecordDecoder]?
        let apiClient: ApiClientProjectsType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchAllProjects { result in
            switch result {
            case .success(let projectsRecordsDecoder):
                expecdedProjectsRecordsDecoder = projectsRecordsDecoder
            case .failure:
                XCTFail()
            }
        }

        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(expecdedProjectsRecordsDecoder?.count, decoder.count)
    }
    
    func testFetchAllProjectsFailed() throws {
        //Arrange
        var expecdedError: Error?
        let error = TestError(message: "fetch projects failed")
        let apiClient: ApiClientProjectsType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchAllProjects { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expecdedError = error
            }
        }
        networkingMock.getCompletion?(.failure(error))
        //Assert
        let testError = try (expecdedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
    
    func testFetchSimpleProjectArrayResponseSucceed() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.simpleProjectArrayResponse)
        let decoder = try JSONDecoder().decode([ProjectDecoder].self, from: data)
        var expecdedProjectsDecoder: [ProjectDecoder]?
        let apiClient: ApiClientProjectsType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchSimpleListOfProjects { result in
            switch result {
            case .success(let projectsDecoder):
                expecdedProjectsDecoder = projectsDecoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(expecdedProjectsDecoder?.count, decoder.count)
    }
    
    func testFetchSimpleProjectArrayResponseFailed() throws {
        //Arrange
        var expecdedError: Error?
        let error = TestError(message: "fetch projects failed")
        let apiClient: ApiClientProjectsType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchSimpleListOfProjects { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                expecdedError = error
            }
        }
        networkingMock.getCompletion?(.failure(error))
        //Assert
        let testError = try (expecdedError as? TestError).unwrap()
        XCTAssertEqual(testError, error)
    }
}
