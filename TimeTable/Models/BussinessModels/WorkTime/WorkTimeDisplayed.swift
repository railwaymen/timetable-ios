//
//  WorkTimeDisplayed.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

struct WorkTimeDisplayed {
    let id: Int64
    let body: String?
    let task: String?
    let taskPreview: String?
    let projectName: String
    let projectColor: UIColor?
    let tag: ProjectTag
    let startsAt: Date
    let endsAt: Date
    let duration: TimeInterval
    let updatedAt: Date?
    let updatedBy: String?
    let changedFields: [TaskVersion.Field]
    
    // MARK: - Initialization
    init(
        id: Int64,
        body: String?,
        task: String?,
        taskPreview: String?,
        projectName: String,
        projectColor: UIColor,
        tag: ProjectTag,
        startsAt: Date,
        endsAt: Date,
        duration: TimeInterval,
        updatedAt: Date?,
        updatedBy: String?,
        changedFields: [TaskVersion.Field]
    ) {
        self.id = id
        self.body = body
        self.task = task
        self.taskPreview = taskPreview
        self.projectName = projectName
        self.projectColor = projectColor
        self.tag = tag
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.duration = duration
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.changedFields = changedFields
    }
    
    init(workTime: WorkTimeDecoder) {
        self.id = workTime.id
        self.body = workTime.body
        self.task = workTime.task
        self.taskPreview = workTime.taskPreview
        self.projectName = workTime.project.name
        self.projectColor = workTime.project.color
        self.tag = workTime.tag
        self.startsAt = workTime.startsAt
        self.endsAt = workTime.endsAt
        self.duration = TimeInterval(workTime.duration)
        self.updatedAt = nil
        self.updatedBy = nil
        self.changedFields = []
    }
    
    init(workTime: WorkTimeDecoder, version: TaskVersion) {
        self.id = workTime.id
        self.body = version.body.newest
        self.task = version.task.newest
        self.taskPreview = version.taskPreview.newest
        self.projectName = version.projectName.newest ?? workTime.project.name
        self.projectColor = nil
        self.tag = version.tag.newest ?? .default
        self.startsAt = version.startsAt.newest ?? workTime.startsAt
        self.endsAt = version.endsAt.newest ?? workTime.endsAt
        self.duration = TimeInterval(version.duration.newest ?? workTime.duration)
        self.updatedAt = version.updatedAt
        self.updatedBy = version.updatedBy
        self.changedFields = version.changes
    }
}

// MARK: - Equatable
extension WorkTimeDisplayed: Equatable {
    static func == (lhs: WorkTimeDisplayed, rhs: WorkTimeDisplayed) -> Bool {
        return lhs.id == rhs.id
    }
}