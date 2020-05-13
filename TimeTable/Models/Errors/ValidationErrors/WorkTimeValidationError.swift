//
//  WorkTimeValidationError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 13/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct WorkTimeValidationError: Error, ValidationErrorType {
    let body: [BodyErrorKey]
    let task: [TaskErrorKey]
    let startsAt: [StartsAtErrorKey]
    let duration: [DurationErrorKey]
    let projectID: [ProjectIDErrorKey]
    
    var isEmpty: Bool {
        return self.body.isEmpty &&
            self.task.isEmpty &&
            self.startsAt.isEmpty &&
            self.duration.isEmpty &&
            self.projectID.isEmpty
    }
    
    private enum CodingKeys: String, CodingKey {
        case body
        case task
        case startsAt = "starts_at"
        case duration = "duration"
        case projectID = "project_id"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let body = try? container.decode([BasicError<BodyErrorKey>].self, forKey: .body)
        self.body = body?.map(\.error) ?? []
        let task = try? container.decode([BasicError<TaskErrorKey>].self, forKey: .task)
        self.task = task?.map(\.error) ?? []
        let startsAt = try? container.decode([BasicError<StartsAtErrorKey>].self, forKey: .startsAt)
        self.startsAt = startsAt?.map(\.error) ?? []
        let duration = try? container.decode([BasicError<DurationErrorKey>].self, forKey: .duration)
        self.duration = duration?.map(\.error) ?? []
        let projectID = try? container.decode([BasicError<ProjectIDErrorKey>].self, forKey: .projectID)
        self.projectID = projectID?.map(\.error) ?? []
    }
}

// MARK: - Structures
extension WorkTimeValidationError {
    enum BodyErrorKey: String, Decodable {
        case bodyOrTaskBlank = "body_or_task_blank"
    }
    
    enum TaskErrorKey: String, Decodable {
        case invalidURI = "invalid_uri"
        case invalidExternal = "invalid_external"
    }
    
    enum StartsAtErrorKey: String, Decodable {
        case overlap
        case tooOld = "too_old"
        case overlapMidnight = "overlap_midnight"
        case noGapsToFill = "no_gaps_to_fill"
    }
    
    enum DurationErrorKey: String, Decodable {
        case greaterThan = "greater_than"
    }
    
    enum ProjectIDErrorKey: String, Decodable {
        case blank
    }
}

// MARK: - LocalizedDescribable
extension WorkTimeValidationError: LocalizedDescribable {
    var localizedDescription: String {
        return self.localizedDescriptions.first ?? ""
    }
    
    private var localizedDescriptions: [String] {
        return self.body.map(\.localizedDescription)
            + self.task.map(\.localizedDescription)
            + self.startsAt.map(\.localizedDescription)
            + self.duration.map(\.localizedDescription)
            + self.projectID.map(\.localizedDescription)
    }
}

extension WorkTimeValidationError.BodyErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .bodyOrTaskBlank: return R.string.localizable.worktimeform_error_body_or_task_blank()
        }
    }
}

extension WorkTimeValidationError.TaskErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .invalidExternal: return R.string.localizable.worktimeform_error_invalid_external()
        case .invalidURI: return R.string.localizable.worktimeform_error_invalid_uri()
        }
    }
}

extension WorkTimeValidationError.StartsAtErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .noGapsToFill: return R.string.localizable.worktimeform_error_no_gaps_to_fill()
        case .overlap: return R.string.localizable.worktimeform_error_overlap()
        case .overlapMidnight: return R.string.localizable.worktimeform_error_overlap_midnight()
        case .tooOld: return R.string.localizable.worktimeform_error_too_old()
        }
    }
}

extension WorkTimeValidationError.DurationErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .greaterThan: return R.string.localizable.worktimeform_error_greater_than()
        }
    }
}

extension WorkTimeValidationError.ProjectIDErrorKey: LocalizedDescribable {
    var localizedDescription: String {
        switch self {
        case .blank: return R.string.localizable.worktimeform_error_blank()
        }
    }
}
