//
//  TaskForm.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 11/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol TaskFormType {
    var workTimeID: Int64? { get set }
    var project: SimpleProjectRecordDecoder? { get set }
    var body: String { get set }
    var urlString: String { get set }
    var day: Date? { get set }
    var startsAt: Date? { get set }
    var endsAt: Date? { get set }
    var tag: ProjectTag { get set }
    var saveWithFilling: Bool { get set }
    
    var title: String { get }
    var allowsTask: Bool { get }
    var isProjectTaggable: Bool { get }
    var projectType: TaskForm.ProjectType? { get }
    var isLunch: Bool { get }
    var isTaskURLHidden: Bool { get }
    
    func generateEncodableRepresentation() throws -> Task
    func validationErrors() -> [TaskForm.ValidationError]
}

struct TaskForm: TaskFormType {
    var workTimeID: Int64?
    var project: SimpleProjectRecordDecoder?
    var body: String
    var urlString: String
    var day: Date?
    var startsAt: Date?
    var endsAt: Date?
    var tag: ProjectTag = .default
    var saveWithFilling: Bool = false
    
    // MARK: - Getters
    var title: String {
        guard let project = self.project else { return R.string.localizable.worktimeform_select_project() }
        return project.name
    }
    
    var allowsTask: Bool {
        guard let project = self.project else { return true }
        return project.workTimesAllowsTask
    }
    
    var isProjectTaggable: Bool {
        self.project?.isTaggable ?? false
    }
    
    var projectType: ProjectType? {
        guard let project = self.project else { return nil }
        if let autofill = project.autofill, autofill {
            return .fullDay(AutofillHours.autofillTimeInterval)
        } else if project.isLunch {
            return .lunch(AutofillHours.lunchTimeInterval)
        }
        return .standard
    }
    
    var isLunch: Bool {
        self.project?.isLunch ?? false
    }
    
    var isTaskURLHidden: Bool {
        !self.allowsTask || self.isLunch
    }
    
    var url: URL? {
        URL(string: self.urlString)
    }
    
    private var isURLValid: Bool {
        self.urlString.isEmpty || self.url != nil
    }
    
    private var requiresBodyOrTaskURL: Bool {
        guard let project = self.project else { return true }
        guard let countDuration = project.countDuration else { return !project.isLunch }
        return !project.isLunch && countDuration
    }
    
    // MARK: - Internal
    func generateEncodableRepresentation() throws -> Task {
        let validationErrors = self.validationErrors()
        if let firstValidationError = validationErrors.first {
            throw firstValidationError
        }
        guard let project = self.project,
            let day = self.day,
            let startsAt = self.startsAt,
            let endsAt = self.endsAt else {
                throw ValidationError.internalError
        }
        return Task(
            project: project,
            body: self.body,
            url: self.url,
            startsAt: try self.combine(day: day, time: startsAt),
            endsAt: try self.combine(day: day, time: endsAt),
            tag: self.tag)
    }
    
    func validationErrors() -> [ValidationError] {
        var errors: [ValidationError] = self.projectDependentValidationErrors()
        if self.day == nil {
            errors.append(.dayIsNil)
        }
        if self.startsAt == nil {
            errors.append(.startsAtIsNil)
        }
        if self.endsAt == nil {
            errors.append(.endsAtIsNil)
        }
        if let startsAt = self.startsAt,
            let endsAt = self.endsAt,
            startsAt >= endsAt {
            errors.append(.timeRangeIsIncorrect)
        }
        return errors
    }
}

// MARK: - Structures
extension TaskForm {
    enum ValidationError: Error, Equatable {
        case bodyIsEmpty
        case dayIsNil
        case endsAtIsNil
        case internalError
        case projectIsNil
        case startsAtIsNil
        case timeRangeIsIncorrect
        case urlStringIsEmpty
        case urlIsInvalid
    }
    
    enum ProjectType: Equatable {
        case standard
        case lunch(TimeInterval)
        case fullDay(TimeInterval)
    }
}

// MARK: - Equatable
extension TaskForm: Equatable {}

// MARK: - Private
extension TaskForm {
    private func combine(day: Date, time: Date) throws -> Date {
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
        guard let date = calendar.date(from: components) else { throw ValidationError.internalError }
        return date
    }
    
    private func projectDependentValidationErrors() -> [ValidationError] {
        var errors: [ValidationError] = []
        if self.project == nil {
            errors.append(.projectIsNil)
        }
        guard self.requiresBodyOrTaskURL else { return errors }
        if let project = self.project {
            if project.workTimesAllowsTask {
                if self.body.isEmpty && self.urlString.isEmpty {
                    errors.append(contentsOf: [.bodyIsEmpty, .urlStringIsEmpty])
                } else if !self.isURLValid {
                    errors.append(.urlIsInvalid)
                }
            } else if self.body.isEmpty {
                errors.append(.bodyIsEmpty)
            }
        } else {
            if self.body.isEmpty {
                errors.append(.bodyIsEmpty)
            }
            if self.urlString.isEmpty {
                errors.append(.urlStringIsEmpty)
            }
            if !self.isURLValid {
                errors.append(.urlIsInvalid)
            }
        }
        return errors
    }
    
    private struct AutofillHours {
        static var lunchTimeInterval: TimeInterval {
            .half(of: .hour)
        }
        
        static var autofillTimeInterval: TimeInterval {
            8 * .hour
        }
    }
}
