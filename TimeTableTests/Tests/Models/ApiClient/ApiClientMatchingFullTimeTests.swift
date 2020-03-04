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
    private var restler: RestlerMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
    }
}

// MARK: - fetchMatchingFullTime(parameters: MatchingFullTimeEncoder, completion: @escaping ((Result<MatchingFullTimeDecoder, Error>) -> Void))
//extension ApiClientMatchingFullTimeTests {
//    func testFetchMatchingFullTimeSucceed() throws {
//        //Arrange
//        let sut = self.buildSUT()
//        let data = try self.json(from: MatchingFullTimeJSONResource.matchingFullTimeFullResponse)
//        var matchingFullTimeDecoder: MatchingFullTimeDecoder?
//        let date = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
//        let matchingFullTime = MatchingFullTimeEncoder(date: date, userId: 1)
//        //Act
//        sut.fetchMatchingFullTime(parameters: matchingFullTime) { result in
//            switch result {
//            case .success(let decoder):
//                matchingFullTimeDecoder = decoder
//            case .failure:
//                XCTFail()
//            }
//        }
//        self.networkingMock.getParams.last?.completion(.success(data))
//        //Assert
//        XCTAssertEqual(matchingFullTimeDecoder?.period?.identifier, 1383)
//        XCTAssertEqual(matchingFullTimeDecoder?.period?.countedDuration, TimeInterval(620100))
//        XCTAssertEqual(matchingFullTimeDecoder?.period?.duration, TimeInterval(633600))
//        XCTAssertEqual(matchingFullTimeDecoder?.shouldWorked, TimeInterval(633600))
//    }
//    
//    func testFetchMatchingFullTimeFailed() throws {
//        //Arrange
//        let sut = self.buildSUT()
//        let error = TestError(message: "fetch matching full time failed")
//        var expectedError: Error?
//        let date = try self.buildDate(year: 2018, month: 1, day: 17, hour: 12, minute: 2, second: 1)
//        let matchingFullTime = MatchingFullTimeEncoder(date: date, userId: 1)
//        //Act
//        sut.fetchMatchingFullTime(parameters: matchingFullTime) { result in
//            switch result {
//            case .success:
//                XCTFail()
//            case .failure(let error):
//                expectedError = error
//            }
//        }
//        self.networkingMock.getParams.last?.completion(.failure(error))
//        //Assert
//        let testError = try XCTUnwrap(expectedError as? TestError)
//        XCTAssertEqual(testError, error)
//    }
//}

// MARK: - Private
extension ApiClientMatchingFullTimeTests {
    private func buildSUT() -> ApiClientMatchingFullTimeType {
        return ApiClient(restler: self.restler)
    }
}
