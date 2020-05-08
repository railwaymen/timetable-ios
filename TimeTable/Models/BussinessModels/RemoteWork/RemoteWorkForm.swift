//
//  RemoteWorkForm.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol RemoteWorkFormType {
    var startsAt: Date { get set }
    var endsAt: Date { get set }
    var note: String { get set }
    
    func convertToEncoder() -> RemoteWorkRequest
}

struct RemoteWorkForm: RemoteWorkFormType {
    var startsAt: Date
    var endsAt: Date
    var note: String
    
    // MARK: - Initialization
    init(
        startDate: Date = Date(),
        endDate: Date = Date(),
        note: String = ""
    ) {
        self.startsAt = startDate
        self.endsAt = endDate
        self.note = note
    }
    
    // MARK: - RemoteWorkFormType
    func convertToEncoder() -> RemoteWorkRequest {
        return RemoteWorkRequest(note: self.note, startsAt: self.startsAt, endsAt: self.endsAt)
    }
}
