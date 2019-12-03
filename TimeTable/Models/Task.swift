//
//  Task.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 11/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct Task {
    var workTimeIdentifier: Int64?
    var project: ProjectDecoder?
    var body: String
    var url: URL?
    var day: Date?
    var startsAt: Date?
    var endsAt: Date?
    var tag: ProjectTag = .default
    
    var title: String {
        switch self.project {
        case .none:
            return "work_time.text_field.select_project".localized
        case .some(let project):
            return project.name
        }
    }
    
    var allowsTask: Bool {
        switch self.project {
        case .none:
            return true
        case .some(let project):
            return project.workTimesAllowsTask
        }
    }
    
    var isTaggable: Bool {
        return self.project?.isTaggable ?? false
    }
    
    var type: ProjectType? {
        switch self.project {
        case .none:
            return nil
        case .some(let project):
            if let autofill = project.autofill, autofill {
                return .fullDay(AutofillHours.autofillTimeInterval)
            } else if project.isLunch {
                return .lunch(AutofillHours.lunchTimeInterval)
            }
            return .standard
        }
    }
}

// MARK: - Structures
extension Task {
    enum ProjectType {
        case standard
        case lunch(TimeInterval)
        case fullDay(TimeInterval)
    }
}

// MARK: - Encodable
extension Task: Encodable {
    enum CodingKeys: String, CodingKey {
        case projectId
        case body
        case task
        case startsAt
        case endsAt
        case tag
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self.project {
        case .none:
            throw EncodingError.invalidValue(ProjectDecoder.self, EncodingError.Context(codingPath: [CodingKeys.projectId], debugDescription: ""))
        case .some(let project):
            try container.encode(project.identifier, forKey: .projectId)
            try container.encode(self.body, forKey: .body)
            try container.encode(self.url, forKey: .task)
            let startAtDate = self.combine(day: self.day, time: self.startsAt)
            try container.encode(startAtDate, forKey: .startsAt)
            let endAtDate = self.combine(day: self.day, time: self.endsAt)
            try container.encode(endAtDate, forKey: .endsAt)
            try? container.encode(self.isTaggable ? self.tag.rawValue : ProjectTag.default.rawValue, forKey: .tag)
        }
    }
}

// MARK: - Equatable
extension Task: Equatable {}

// MARK: - Private
extension Task {
    private func combine(day: Date?, time: Date?) -> Date? {
        guard let day = day, let time = time else { return nil }
        let calendar = Calendar.autoupdatingCurrent
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: day)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = 0
        return calendar.date(from: components)
    }
    
    private struct AutofillHours {
        private static let seconds = 60
        private static let minutes = 60
        static var lunchTimeInterval: TimeInterval {
            return TimeInterval(AutofillHours.seconds * 30)
        }
        static var autofillTimeInterval: TimeInterval {
            return TimeInterval(AutofillHours.seconds * AutofillHours.minutes * 8)
        }
    }
}
