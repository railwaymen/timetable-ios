//
//  WorkTimesContentProviderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimesContentProviderMock: WorkTimesContentProviderType {
    private(set) var fetchWorkTimesDataValues: (called: Bool, date: Date?) = (false, nil)
    private(set) var fetchWorkTimesDataCompletion: ((Result<([DailyWorkTime], MatchingFullTimeDecoder)>) -> Void)?
    func fetchWorkTimesData(for date: Date?, completion: @escaping (Result<([DailyWorkTime], MatchingFullTimeDecoder)>) -> Void) {
        fetchWorkTimesDataValues = (true, date)
        fetchWorkTimesDataCompletion = completion
    }
    
    private(set) var deleteWorkTimeDecoder: WorkTimeDecoder?
    private(set) var deleteWorkTimeCompletion: ((Result<Void>) -> Void)?
    func delete(workTime: WorkTimeDecoder, completion: @escaping (Result<Void>) -> Void) {
        deleteWorkTimeDecoder = workTime
        deleteWorkTimeCompletion = completion
    }
}
