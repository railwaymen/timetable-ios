//
//  RemoteWorkForm.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol RemoteWorkFormType {
    var startDate: Date { get set }
    var endDate: Date { get set }
    var note: String { get set }
    
    func convertToEncoder() -> RemoteWorkRequest
}

struct RemoteWorkForm: RemoteWorkFormType {
    var startDate: Date
    var endDate: Date
    var note: String
    
    // MARK: - Initialization
    init(
        startDate: Date = Date(),
        endDate: Date = Date(),
        note: String = ""
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.note = note
    }
    
    // MARK: - RemoteWorkFormType
    func convertToEncoder() -> RemoteWorkRequest {
        return RemoteWorkRequest(note: self.note, startsAt: self.startDate, endsAt: self.endDate)
    }
}
