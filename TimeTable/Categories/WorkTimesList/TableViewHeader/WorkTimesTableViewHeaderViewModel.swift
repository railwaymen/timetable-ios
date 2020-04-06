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
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default
        return formatter
    }()
    
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
        if self.calendar.isDateInToday(self.dailyWorkTime.day) {
            dayText = "day.today".localized
        } else if self.calendar.isDateInYesterday(self.dailyWorkTime.day) {
            dayText = "day.yesterday".localized
        } else {
            dayText = DateFormatter.mediumDate.string(from: self.dailyWorkTime.day)
        }
        let duration = TimeInterval(self.dailyWorkTime.workTimes.map(\.duration).reduce(0, +))
        let durationText = self.dateComponentsFormatter.string(from: duration)
        self.userInterface?.updateView(dayText: dayText, durationText: durationText)
    }
}
