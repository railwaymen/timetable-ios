//
//  WorkTimesTableViewHeaderViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimesTableViewHeaderViewModelOutput: class {
    func updateView(dayText: String?, durationText: String?)
}

protocol WorkTimesTableViewHeaderViewModelType: class {
    func viewConfigured()
}

class WorkTimesTableViewHeaderViewModel {
    private weak var userInterface: WorkTimesTableViewHeaderViewModelOutput?
    private let calendar: CalendarType
    private let dailyWorkTime: DailyWorkTime
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimesTableViewHeaderViewModelOutput,
        dailyWorkTime: DailyWorkTime,
        calendar: CalendarType = Calendar.autoupdatingCurrent
    ) {
        self.userInterface = userInterface
        self.dailyWorkTime = dailyWorkTime
        self.calendar = calendar
    }
}
 
// MARK: - WorkTimesTableViewHeaderViewModelType
extension WorkTimesTableViewHeaderViewModel: WorkTimesTableViewHeaderViewModelType {
    func viewConfigured() {
        var dayText: String?
        let dateFormatter = DateFormatterBuilder()
            .dateStyle(.medium)
            .setRelativeDateFormatting(true)
            .build()
        dayText = dateFormatter.string(from: self.dailyWorkTime.day)
        let duration = TimeInterval(self.dailyWorkTime.workTimes.map(\.duration).reduce(0, +))
        let durationText = DateComponentsFormatter.timeAbbreviated.string(from: duration)
        self.userInterface?.updateView(dayText: dayText, durationText: durationText)
    }
}
