//
//  WorkTimesListContentProviderMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 31/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class WorkTimesListContentProviderMock {
    private(set) var fetchWorkTimesDataParams: [FetchWorkTimesDataParams] = []
    struct FetchWorkTimesDataParams {
        var date: Date?
        var completion: (Result<([DailyWorkTime], MatchingFullTimeDecoder), Error>) -> Void
    }
    
    private(set) var deleteWorkTimeParams: [DeleteWorkTimeParams] = []
    struct DeleteWorkTimeParams {
        var workTime: WorkTimeDecoder
        var completion: (Result<Void, Error>) -> Void
    }
}

// MARK: - WorkTimesListContentProviderType
extension WorkTimesListContentProviderMock: WorkTimesListContentProviderType {
    func fetchWorkTimesData(for date: Date?, completion: @escaping (Result<([DailyWorkTime], MatchingFullTimeDecoder), Error>) -> Void) {
        self.fetchWorkTimesDataParams.append(FetchWorkTimesDataParams(date: date, completion: completion))
    }
    
    func delete(workTime: WorkTimeDecoder, completion: @escaping (Result<Void, Error>) -> Void) {
        self.deleteWorkTimeParams.append(DeleteWorkTimeParams(workTime: workTime, completion: completion))
    }
}
