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

class WorkTimesTableViewHeaderViewModel: WorkTimesTableViewHeaderViewModelType {
    private weak var userInterface: WorkTimesTableViewHeaderViewModelOutput?
    private let calendar: CalendarType
    private let dailyWorkTime: DailyWorkTime
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    // MARK: - Initialization
    init(userInterface: WorkTimesTableViewHeaderViewModelOutput, dailyWorkTime: DailyWorkTime, calendar: CalendarType = Calendar.autoupdatingCurrent) {
        self.userInterface = userInterface
        self.dailyWorkTime = dailyWorkTime
        self.calendar = calendar
    }
    
    // MARK: - WorkTimesTableViewHeaderViewModelType
    func viewConfigured() {
        var dayText: String?
        if calendar.isDateInToday(dailyWorkTime.day) {
            dayText = "day.today".localized
        } else if calendar.isDateInYesterday(dailyWorkTime.day) {
            dayText = "day.yesterday".localized
        } else {
            dayText = DateFormatter.localizedString(from: dailyWorkTime.day, dateStyle: .medium, timeStyle: .none)
        }
        let duration = TimeInterval(dailyWorkTime.workTimes.reduce(0) { $0 + $1.duration})
        let durationText = dateComponentsFormatter.string(from: duration)
        userInterface?.updateView(dayText: dayText, durationText: durationText)
    }
}
