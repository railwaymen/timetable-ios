//
//  TimesheetContentProviderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class TimesheetContentProviderMock {
    
    // MARK: - TimesheetContentProviderType
    private(set) var fetchRequiredDataParams: [FetchRequiredDataParams] = []
    struct FetchRequiredDataParams {
        let date: Date?
        let completion: TimesheetFetchRequiredDataCompletion
    }
    
    private(set) var fetchWorkTimesDataParams: [FetchWorkTimesDataParams] = []
    struct FetchWorkTimesDataParams {
        let date: Date?
        let completion: TimesheetFetchCompletion
    }
    
    private(set) var deleteWorkTimeParams: [DeleteWorkTimeParams] = []
    struct DeleteWorkTimeParams {
        let workTime: WorkTimeDecoder
        let completion: TimesheetDeleteCompletion
    }
}

// MARK: - TimesheetContentProviderType
extension TimesheetContentProviderMock: TimesheetContentProviderType {
    func fetchRequiredData(for date: Date?, completion: @escaping TimesheetFetchRequiredDataCompletion) {
        self.fetchRequiredDataParams.append(FetchRequiredDataParams(date: date, completion: completion))
    }
    
    func fetchWorkTimesData(for date: Date?, completion: @escaping TimesheetFetchCompletion) {
        self.fetchWorkTimesDataParams.append(FetchWorkTimesDataParams(date: date, completion: completion))
    }
    
    func delete(workTime: WorkTimeDecoder, completion: @escaping TimesheetDeleteCompletion) {
        self.deleteWorkTimeParams.append(DeleteWorkTimeParams(workTime: workTime, completion: completion))
    }
}
