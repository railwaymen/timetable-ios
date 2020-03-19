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
    var workTimeIdentifier: Int64?
    var project: SimpleProjectRecordDecoder?
    var body: String = ""
    var url: URL?
    var day: Date?
    var startsAt: Date?
    var endsAt: Date?
    var tag: ProjectTag = .default
    
    var titleReturnValue: String = ""
    
    var allowsTaskReturnValue: Bool = false
    
    var isProjectTaggableReturnValue: Bool = false
    
    var projectTypeReturnValue: TaskForm.ProjectType?
    
    var generateEncodableRepresentationThrownError: Error?
    var generateEncodableRepresentationReturnValue: Task!
    private(set) var generateEncodableRepresentationParams: [GenerateEncodableRepresentationParams] = []
    struct GenerateEncodableRepresentationParams {}
}

// MARK: - TaskFormType
extension TaskFormMock: TaskFormType {
    var title: String {
        return self.titleReturnValue
    }
    
    var allowsTask: Bool {
        return self.allowsTaskReturnValue
    }
    
    var isProjectTaggable: Bool {
        return self.isProjectTaggableReturnValue
    }
    
    var projectType: TaskForm.ProjectType? {
        return self.projectTypeReturnValue
    }
    
    func generateEncodableRepresentation() throws -> Task {
        self.generateEncodableRepresentationParams.append(GenerateEncodableRepresentationParams())
        if let error = self.generateEncodableRepresentationThrownError {
            throw error
        }
        return try XCTUnwrap(self.generateEncodableRepresentationReturnValue)
    }
}
