//
//  ApiClientMatchingFullTimeTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 04/02/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ApiClientMatchingFullTimeTests: XCTestCase {
    
    private var networkingMock: NetworkingMock!
    private var requestEncoderMock: RequestEncoderMock!
    private var jsonDecoderMock: JSONDecoderMock!
    private var apiClient: ApiClientMatchingFullTimeType!
    
    private enum MatchingFullTimeResponse: String, JSONFileResource {
        case matchingFullTimeFullResponse
    }
    
    override func setUp() {
        self.networkingMock = NetworkingMock()
        self.requestEncoderMock = RequestEncoderMock()
        self.jsonDecoderMock = JSONDecoderMock()
        self.apiClient = ApiClient(networking: networkingMock, encoder: requestEncoderMock, decoder: jsonDecoderMock)
        super.setUp()
    }
    
    func testFetchMatchingFullTimeSucceed() throws {
        //Arrange
        let data = try self.json(from: MatchingFullTimeResponse.matchingFullTimeFullResponse)
        var matchingFullTimeDecoder: MatchingFullTimeDecoder?
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let date = try Calendar.current.date(from: components).unwrap()
        let matchingFullTime = MatchingFullTimeEncoder(date: date, userIdentifier: 1)
        //Act
        apiClient.fetchMatchingFullTime(parameters: matchingFullTime) { result in
            switch result {
            case .success(let decoder):
                matchingFullTimeDecoder = decoder
            case .failure:
                XCTFail()
            }
        }
        networkingMock.getCompletion?(.success(data))
        //Assert
        XCTAssertEqual(matchingFullTimeDecoder?.period?.identifier, 1383)
        XCTAssertEqual(matchingFullTimeDecoder?.period?.countedDuration, TimeInterval(620100))
        XCTAssertEqual(matchingFullTimeDecoder?.period?.duration, TimeInterval(633600))
        XCTAssertEqual(matchingFullTimeDecoder?.shouldWorked, TimeInterval(633600))
    }
    
    func testFetchMatchingFullTimeFailed() throws {
        //Arrange
        let error = TestError(message: "fetch matching full time failed")
        var expectedError: Error?
        let components = DateComponents(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
        let date = try Calendar.current.date(from: components).unwrap()
        let matchingFullTime = MatchingFullTimeEncoder(date: date, userIdentifier: 1)
        //Act
        apiClient.fetchMatchingFullTime(parameters: matchingFullTime) { result in
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
