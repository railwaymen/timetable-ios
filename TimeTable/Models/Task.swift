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
        guard let project = self.project else { return "work_time.text_field.select_project".localized }
        return project.name
    }
    
    var allowsTask: Bool {
        guard let project = self.project else { return true }
        return project.workTimesAllowsTask
    }
    
    var isTaggable: Bool {
        return self.project?.isTaggable ?? false
    }
    
    var type: ProjectType? {
        guard let project = self.project else { return nil }
        if let autofill = project.autofill, autofill {
            return .fullDay(AutofillHours.autofillTimeInterval)
        } else if project.isLunch {
            return .lunch(AutofillHours.lunchTimeInterval)
        }
        return .standard
    }
    
    func validate() throws {
        guard let project = self.project else { throw TaskValidationError.projectIsNil }
        if !project.isLunch && project.countDuration ?? true {
            guard !self.body.isEmpty else { throw TaskValidationError.bodyIsEmpty }
            guard !self.allowsTask || self.url != nil else { throw TaskValidationError.urlIsNil }
        }
        guard let startsAt = self.startsAt else { throw TaskValidationError.startsAtIsNil }
        guard let endsAt = self.endsAt else { throw TaskValidationError.endsAtIsNil }
        guard startsAt < endsAt else { throw TaskValidationError.timeRangeIsIncorrect }
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
        static var lunchTimeInterval: TimeInterval {
            return 30 * .minute
        }
        
        static var autofillTimeInterval: TimeInterval {
            return 8 * .hour
        }
    }
}
