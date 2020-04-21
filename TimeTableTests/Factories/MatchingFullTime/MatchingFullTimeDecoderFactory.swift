//
//  MatchingFullTimeDecoderFactory.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 20/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import JSONFactorable
@testable import TimeTable

class MatchingFullTimeDecoderFactory: JSONFactorable {
    func build(
        accountingPeriod: MatchingFullTimeDecoder.Period? = nil,
        shouldWorked: TimeInterval? = nil
    ) throws -> MatchingFullTimeDecoder {
        let wrapper = Wrapper(
            accountingPeriod: accountingPeriod,
            shouldWorked: shouldWorked)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
    
    func buildPeriod(
        id: Int = 1,
        countedDuration: TimeInterval = 60,
        duration: TimeInterval = 60
    ) throws -> MatchingFullTimeDecoder.Period {
        let wrapper = PeriodWrapper(
            id: id,
            countedDuration: countedDuration,
            duration: duration)
        return try self.buildObject(of: wrapper.jsonConvertible())
    }
}

// MARK: - Structures
extension MatchingFullTimeDecoderFactory {
    struct Wrapper: MatchingFullTimeDecoderFields {
        let accountingPeriod: MatchingFullTimeDecoder.Period?
        let shouldWorked: TimeInterval?
        
        init(
            accountingPeriod: MatchingFullTimeDecoder.Period?,
            shouldWorked: TimeInterval?
        ) {
            self.accountingPeriod = accountingPeriod
            self.shouldWorked = shouldWorked
        }
        
        func jsonConvertible() throws -> AnyJSONConvertible {
            return [
                "accounting_period": AnyJSONConvertible(self.accountingPeriod),
                "should_worked": AnyJSONConvertible(self.shouldWorked)
            ]
        }
    }
    
    struct PeriodWrapper: MatchingFullTimePeriodDecoder {
        let id: Int
        let countedDuration: TimeInterval
        let duration: TimeInterval
        
        init(
            id: Int,
            countedDuration: TimeInterval,
            duration: TimeInterval
        ) {
            self.id = id
            self.countedDuration = countedDuration
            self.duration = duration
        }
        
        func jsonConvertible() -> AnyJSONConvertible {
            return [
                "id": AnyJSONConvertible(self.id),
                "counted_duration": AnyJSONConvertible(self.countedDuration),
                "duration": AnyJSONConvertible(self.duration)
            ]
        }
    }
}

// MARK: - Helper extensions
extension MatchingFullTimeDecoder: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = MatchingFullTimeDecoderFactory.Wrapper(
            accountingPeriod: self.accountingPeriod,
            shouldWorked: self.shouldWorked)
        return try wrapper.jsonConvertible()
    }
}

extension MatchingFullTimeDecoder.Period: JSONObjectType {
    public func jsonConvertible() throws -> JSONConvertible {
        let wrapper = MatchingFullTimeDecoderFactory.PeriodWrapper(
            id: self.id,
            countedDuration: self.countedDuration,
            duration: self.duration)
        return wrapper.jsonConvertible()
    }
}
