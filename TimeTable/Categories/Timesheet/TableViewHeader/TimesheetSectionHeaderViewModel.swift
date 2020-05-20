//
//  TimesheetSectionHeaderViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol TimesheetSectionHeaderViewModelOutput: class {
    func updateView(dayText: String?, durationText: String?)
}

protocol TimesheetSectionHeaderViewModelType: class {
    func viewConfigured()
}

class TimesheetSectionHeaderViewModel {
    private weak var userInterface: TimesheetSectionHeaderViewModelOutput?
    private let calendar: CalendarType
    private let dailyWorkTime: DailyWorkTime
    
    // MARK: - Initialization
    init(
        userInterface: TimesheetSectionHeaderViewModelOutput,
        dailyWorkTime: DailyWorkTime,
        calendar: CalendarType = Calendar.autoupdatingCurrent
    ) {
        self.userInterface = userInterface
        self.dailyWorkTime = dailyWorkTime
        self.calendar = calendar
    }
}
 
// MARK: - TimesheetSectionHeaderViewModelType
extension TimesheetSectionHeaderViewModel: TimesheetSectionHeaderViewModelType {
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
