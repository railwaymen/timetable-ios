//
//  ApiClient+WorkTimes.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientWorkTimesTests: XCTestCase {
    
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
 
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    private enum WorkTimesResponse: String, JSONFileResource {
        case workTimesResponse
    }
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        super.setUp()
    }

    // MARK: - ApiClientWorkTimesType
    func testFetchSucced() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let decoders = try decoder.decode([WorkTimeDecoder].self, from: data)
        var expecdedWorkTimes: [WorkTimeDecoder]?
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        let apiClient: ApiClientWorkTimesType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchWorkTimes(parameters: parameters) { result in
            switch result {
            case .success(let workTimeDecoder):
                expecdedWorkTimes = workTimeDecoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(try (expecdedWorkTimes?[0]).unwrap(), decoders[0])
        XCTAssertEqual(try (expecdedWorkTimes?[1]).unwrap(), decoders[1])
    }
    
    func testFetchFailed() throws {
        //Arrange
        var expecdedError: Error?
        let error = TestError(messsage: "fetch failed")
        let parameters = WorkTimesParameters(fromDate: nil, toDate: nil, projectIdentifier: nil)
        let apiClient: ApiClientWorkTimesType = ApiClient(networking: networkingMock, buildEncoder: { () -> RequestEncoderType in
            return requestEncoderMock
        }) { () -> JSONDecoderType in
            return jsonDecoderMock
        }
        //Act
        apiClient.fetchWorkTimes(parameters: parameters) { result in
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
