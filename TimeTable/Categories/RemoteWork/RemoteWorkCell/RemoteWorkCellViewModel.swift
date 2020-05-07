//
//  RemoteWorkCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol RemoteWorkCellViewModelType: class {
    func viewConfigured()
}

protocol RemoteWorkCellViewModelOutput: class {
    func updateView(day: String, timeInterval: String, duration: String?, note: String?)
}

class RemoteWorkCellViewModel {
    private weak var userInterface: RemoteWorkCellViewModelOutput?
    private let remoteWork: RemoteWork
    
    // MARK: - Initialization
    init(
        userInterface: RemoteWorkCellViewModelOutput,
        remoteWork: RemoteWork
    ) {
        self.userInterface = userInterface
        self.remoteWork = remoteWork
    }
}

// MARK: - RemoteWorkCellViewModelType
extension RemoteWorkCellViewModel: RemoteWorkCellViewModelType {
    func viewConfigured() {
        let day = DateFormatter.shortDate.string(from: self.remoteWork.startsAt)
        let startsAtHours = DateFormatter.shortTime.string(from: self.remoteWork.startsAt)
        let endsAtHours = DateFormatter.shortTime.string(from: self.remoteWork.endsAt)
        self.userInterface?.updateView(
            day: day,
            timeInterval: "\(startsAtHours) - \(endsAtHours)",
            duration: DateComponentsFormatter.timeAbbreviated.string(from: self.remoteWork.duration),
            note: self.remoteWork.note)
    }
}
