//
//  TaskFormFactory.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 31/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol TaskFormFactoryType: class {
    func buildTaskForm(duplicatedTask: TaskForm?, lastTask: TaskForm?) -> TaskFormType
}

class TaskFormFactory {
    private let calendar: CalendarType
    
    // MARK: - Initialization
    init(calendar: CalendarType) {
        self.calendar = calendar
    }
}

// MARK: - TaskFormFactoryType
extension TaskFormFactory: TaskFormFactoryType {
    func buildTaskForm(duplicatedTask: TaskForm?, lastTask: TaskForm?) -> TaskFormType {
        return TaskForm(
            workTimeIdentifier: nil,
            project: duplicatedTask?.project,
            body: duplicatedTask?.body ?? "",
            url: duplicatedTask?.url,
            day: Date(),
            startsAt: self.pickEndTime(ofLastTask: lastTask),
            endsAt: nil,
            tag: duplicatedTask?.tag ?? .default)
    }
}

// MARK: - Private
extension TaskFormFactory {
    private func pickEndTime(ofLastTask lastTask: TaskForm?) -> Date? {
        guard let lastTaskEndAt = lastTask?.endsAt,
            self.calendar.isDateInToday(lastTaskEndAt) else { return nil }
        return lastTaskEndAt
    }
}
