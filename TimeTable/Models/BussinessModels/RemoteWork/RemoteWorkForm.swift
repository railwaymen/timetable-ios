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
    
    func validationErrors() -> [UIError]
    func convertToEncoder() throws -> RemoteWorkRequest
}

struct RemoteWorkForm: RemoteWorkFormType {
    var startsAt: Date
    var endsAt: Date
    var note: String
    
    // MARK: - Initialization
    init(
        startsAt: Date = Date(),
        endsAt: Date = Date(),
        note: String = ""
    ) {
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.note = note
    }
    
    // MARK: - RemoteWorkFormType
    func validationErrors() -> [UIError] {
        guard self.startsAt >= self.endsAt else { return [] }
        return [.remoteWorkStatsAtIncorrectHours]
    }
    
    func convertToEncoder() throws -> RemoteWorkRequest {
        let errors = self.validationErrors()
        if let first = errors.first {
            throw first
        }
        return RemoteWorkRequest(note: self.note, startsAt: self.startsAt, endsAt: self.endsAt)
    }
}
