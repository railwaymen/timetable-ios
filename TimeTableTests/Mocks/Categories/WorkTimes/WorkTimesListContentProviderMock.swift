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
    
    // MARK: - WorkTimesListContentProviderType
    private(set) var fetchRequiredDataParams: [FetchRequiredDataParams] = []
    struct FetchRequiredDataParams {
        let date: Date?
        let completion: WorkTimesListFetchRequiredDataCompletion
    }
    
    private(set) var fetchWorkTimesDataParams: [FetchWorkTimesDataParams] = []
    struct FetchWorkTimesDataParams {
        let date: Date?
        let completion: WorkTimesListFetchCompletion
    }
    
    private(set) var deleteWorkTimeParams: [DeleteWorkTimeParams] = []
    struct DeleteWorkTimeParams {
        let workTime: WorkTimeDecoder
        let completion: WorkTimesListDeleteCompletion
    }
}

// MARK: - WorkTimesListContentProviderType
extension WorkTimesListContentProviderMock: WorkTimesListContentProviderType {
    func fetchRequiredData(for date: Date?, completion: @escaping WorkTimesListFetchRequiredDataCompletion) {
        self.fetchRequiredDataParams.append(FetchRequiredDataParams(date: date, completion: completion))
    }
    
    func fetchWorkTimesData(for date: Date?, completion: @escaping WorkTimesListFetchCompletion) {
        self.fetchWorkTimesDataParams.append(FetchWorkTimesDataParams(date: date, completion: completion))
    }
    
    func delete(workTime: WorkTimeDecoder, completion: @escaping WorkTimesListDeleteCompletion) {
        self.deleteWorkTimeParams.append(DeleteWorkTimeParams(workTime: workTime, completion: completion))
    }
}
