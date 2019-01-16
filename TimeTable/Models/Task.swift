//
//  Task.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 11/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

struct Task: Encodable {
    var project: ProjectDecoder?
    var body: String
    var url: URL?
    var fromDate: Date?
    var toDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case body
        case task
        case fromDate = "starts_at"
        case toDate = "ends_at"
    }
    
    var title: String {
        switch project {
        case .none:
            return "work_time.text_field.select_project".localized
        case .some(let project):
            return project.name
        }
    }
    
    var allowsTask: Bool {
        switch project {
        case .none:
            return false
        case .some(let project):
            return project.workTimesAllowsTask
        }
    }
    
    var type: ProjectType? {
        switch project {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch project {
        case .none:
            throw EncodingError.invalidValue(ProjectDecoder.self, EncodingError.Context(codingPath: [CodingKeys.projectId], debugDescription: ""))
        case .some(let project):
            try container.encode(project.identifier, forKey: .projectId)
            try container.encode(body, forKey: .body)
            try container.encode(url, forKey: .task)
            try container.encode(fromDate, forKey: .fromDate)
            try container.encode(toDate, forKey: .toDate)
        }
    }
    
    private struct AutofillHours {
        private static let seconds = 60
        private static let minutes = 60
        static var lunchTimeInterval: TimeInterval {
            return TimeInterval(AutofillHours.seconds * 30)
        }
        static  var autofillTimeInterval: TimeInterval {
            return TimeInterval(AutofillHours.seconds * AutofillHours.minutes * 8)
        }
    }

    enum ProjectType {
        case standard
        case lunch(TimeInterval)
        case fullDay(TimeInterval)
    }
}
