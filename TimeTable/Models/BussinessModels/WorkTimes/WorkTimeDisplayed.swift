//
//  WorkTimeDisplayed.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 17/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

struct WorkTimeDisplayed {
    let identifier: Int64
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
    
    // MARK: - Initialization
    init(
        identifier: Int64,
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
        updatedBy: String?
    ) {
        self.identifier = identifier
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
    }
    
    init(workTime: WorkTimeDecoder) {
        self.identifier = workTime.identifier
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
    }
    
    init(workTime: WorkTimeDecoder, version: TaskVersion) {
        self.identifier = workTime.identifier
        self.body = version.body.newest
        self.task = nil
        self.taskPreview = nil
        self.projectName = version.projectName.newest ?? workTime.project.name
        self.projectColor = nil
        self.tag = version.tag.newest ?? workTime.tag
        self.startsAt = version.startsAt.newest ?? workTime.startsAt
        self.endsAt = version.endsAt.newest ?? workTime.endsAt
        self.duration = TimeInterval(version.duration.newest ?? workTime.duration)
        self.updatedAt = version.updatedAt
        self.updatedBy = version.updatedBy
    }
}

// MARK: - Equatable
extension WorkTimeDisplayed: Equatable {
    static func == (lhs: WorkTimeDisplayed, rhs: WorkTimeDisplayed) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
