//
//  Asserts.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

/// Calls `XCTFail` if error of the given result isn't expected error case.
///
/// It does simple switch on the result to determine if the case is the same.
/// It doesn't use `Equatable` protocol of the enum.
///
/// - Parameters:
///   - result: Closure returning Result. Error of the result is compared to the given expected case.
///   - expectedCase: Case of the enum to check if it's equal to. The associated value of the given case is ignored.
///   - file: File passed to `XCTFail` function.
///   - line: Line passed to `XCTFail` function.
///
/// - Note:
///   Associated value is ignored
///
func AssertResult<T, U>(
    _ result: @autoclosure () throws -> Result<T, Error>,
    errorCaseIs expectedCase: U,
    file: StaticString = #file,
    line: UInt = #line
) where U: Error & UniqueValuedEnumerator {
    do {
        try result().validateEqualityErrorCase(to: expectedCase)
    } catch let error as ResultTestError {
        XCTFail(error.message, file: file, line: line)
    } catch {
        XCTFail("Unexpected error", file: file, line: line)
    }
}

/// Calls `XCTFail` if error of the given result is not equal to expected error.
///
/// It determines if the result is `failure` with an error equal to the given test error.
///
/// - Parameters:
///   - result: Closure returning Result. Error of the result is compared to the given expected error.
///   - expectedError: Equatable error expected in result failure.
///   - file: File passed to `XCTFail` function.
///   - line: Line passed to `XCTFail` function.
///
func AssertResult<T, U>(
    _ result: @autoclosure () throws -> Result<T, Error>,
    errorIsEqualTo expectedError: U,
    file: StaticString = #file,
    line: UInt = #line
) where U: Error & Equatable {
    do {
        try result().validateEqualityTestError(to: expectedError)
    } catch let error as ResultTestError {
        XCTFail(error.message, file: file, line: line)
    } catch {
        XCTFail("Unexpected error", file: file, line: line)
    }
}

// MARK: - Private extensions
private extension Result where Failure == Error {
    func validateEqualityErrorCase<U>(to errorCase: U) throws where U: Error & UniqueValuedEnumerator {
        guard case let .failure(error) = self else {
            throw ResultTestError.failureExpected
        }
        guard let apiClientError = error as? U else {
            throw ResultTestError.errorTypeInvalid(current: "\(error)", expected: "\(U.self)")
        }
        guard apiClientError.uniqueValue == errorCase.uniqueValue else {
            throw ResultTestError.casesNotEqual(current: "\(errorCase)", expected: "\(apiClientError)")
        }
    }
    
    func validateEqualityTestError<U>(to testError: U) throws where U: Error & Equatable {
        guard case let .failure(error) = self else {
            throw ResultTestError.failureExpected
        }
        guard let selfTestError = error as? U else {
            throw ResultTestError.errorTypeInvalid(current: "\(error)", expected: "\(U.self)")
        }
        guard selfTestError == testError else {
            throw ResultTestError.valuesNotEqual(current: "\(selfTestError)", expected: "\(testError)")
        }
    }
}

// MARK: - Private structures
private enum ResultTestError: Error {
    case failureExpected
    case errorTypeInvalid(current: String, expected: String)
    case casesNotEqual(current: String, expected: String)
    case valuesNotEqual(current: String, expected: String)
    
    var message: String {
        switch self {
        case .failureExpected:
            return "Result is expected to be failure, but it is success instead."
        case let .errorTypeInvalid(current, expected):
            return "Error is \(current) instead of being \(expected)"
        case let .casesNotEqual(current, expected):
            return "Case is \(current) instead of expected \(expected)"
        case let .valuesNotEqual(current, expected):
            return "Value is \(current) instead of expected \(expected)"
        }
    }
}
