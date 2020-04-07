//
//  TaskFormMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskFormMock {
    
    // MARK: - TaskFormType
    var workTimeIdentifierReturnValue: Int64?
    private(set) var workTimeIdentifierSetParams: [WorkTimeIdentifierSetParams] = []
    struct WorkTimeIdentifierSetParams {
        let newValue: Int64?
    }
    
    var projectReturnValue: SimpleProjectRecordDecoder?
    private(set) var projectSetParams: [ProjectSetParams] = []
    struct ProjectSetParams {
        let newValue: SimpleProjectRecordDecoder?
    }
    
    var bodyReturnValue: String = ""
    private(set) var bodySetParams: [BodySetParams] = []
    struct BodySetParams {
        let newValue: String
    }
    
    var urlStringReturnValue: String = ""
    private(set) var urlStringSetParams: [URLStringSetParams] = []
    struct URLStringSetParams {
        let newValue: String
    }
    
    var dayReturnValue: Date?
    private(set) var daySetParams: [DaySetParams] = []
    struct DaySetParams {
        let newValue: Date?
    }
    
    var startsAtReturnValue: Date?
    private(set) var startsAtParams: [StartsAtParams] = []
    struct StartsAtParams {
        let newValue: Date?
    }
    
    var endsAtReturnValue: Date?
    private(set) var endsAtParams: [EndsAtParams] = []
    struct EndsAtParams {
        let newValue: Date?
    }
    
    var tagReturnValue: ProjectTag = .default
    private(set) var tagSetParams: [TagSetParams] = []
    struct TagSetParams {
        let newValue: ProjectTag
    }
    
    var titleReturnValue: String = ""
    
    var allowsTaskReturnValue: Bool = false
    
    var isProjectTaggableReturnValue: Bool = false
    
    var projectTypeReturnValue: TaskForm.ProjectType?
    
    var generateEncodableRepresentationThrownError: Error?
    var generateEncodableRepresentationReturnValue: Task!
    private(set) var generateEncodableRepresentationParams: [GenerateEncodableRepresentationParams] = []
    struct GenerateEncodableRepresentationParams {}
    
    var validationErrorsReturnValue: [TaskForm.ValidationError] = []
    private(set) var validationErrorsParams: [ValidationErrorsParams] = []
    struct ValidationErrorsParams {}
}

// MARK: - TaskFormType
extension TaskFormMock: TaskFormType {
    var workTimeIdentifier: Int64? {
        get {
            self.workTimeIdentifierReturnValue
        }
        set {
            self.workTimeIdentifierSetParams.append(WorkTimeIdentifierSetParams(newValue: newValue))
        }
    }
    
    var project: SimpleProjectRecordDecoder? {
        get {
            self.projectReturnValue
        }
        set {
            self.projectSetParams.append(ProjectSetParams(newValue: newValue))
        }
    }
    
    var body: String {
        get {
            self.bodyReturnValue
        }
        set {
            self.bodySetParams.append(BodySetParams(newValue: newValue))
        }
    }
    
    var urlString: String {
        get {
            self.urlStringReturnValue
        }
        set {
            self.urlStringSetParams.append(URLStringSetParams(newValue: newValue))
        }
    }
    
    var day: Date? {
        get {
            self.dayReturnValue
        }
        set {
            self.daySetParams.append(DaySetParams(newValue: newValue))
        }
    }
    
    var startsAt: Date? {
        get {
            self.startsAtReturnValue
        }
        set {
            self.startsAtParams.append(StartsAtParams(newValue: newValue))
        }
    }
    
    var endsAt: Date? {
        get {
            self.endsAtReturnValue
        }
        set {
            self.endsAtParams.append(EndsAtParams(newValue: newValue))
        }
    }
    
    var tag: ProjectTag {
        get {
            self.tagReturnValue
        }
        set {
            self.tagSetParams.append(TagSetParams(newValue: newValue))
        }
    }
    
    var title: String {
        self.titleReturnValue
    }
    
    var allowsTask: Bool {
        self.allowsTaskReturnValue
    }
    
    var isProjectTaggable: Bool {
        self.isProjectTaggableReturnValue
    }
    
    var projectType: TaskForm.ProjectType? {
        self.projectTypeReturnValue
    }
    
    func generateEncodableRepresentation() throws -> Task {
        self.generateEncodableRepresentationParams.append(GenerateEncodableRepresentationParams())
        if let error = self.generateEncodableRepresentationThrownError {
            throw error
        }
        return try XCTUnwrap(self.generateEncodableRepresentationReturnValue)
    }
    
    func validationErrors() -> [TaskForm.ValidationError] {
        self.validationErrorsParams.append(ValidationErrorsParams())
        return self.validationErrorsReturnValue
    }
}
