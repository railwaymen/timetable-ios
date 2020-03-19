//
//  TaskFactory.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TaskFactory {
    func build(
        workTimeIdentifier: Int64? = nil,
        project: SimpleProjectRecordDecoder? = nil,
        body: String = "",
        url: URL? = nil,
        day: Date? = nil,
        startsAt: Date? = nil,
        endsAt: Date? = nil,
        tag: ProjectTag = .default
    ) -> TaskForm {
        return TaskForm(
            workTimeIdentifier: workTimeIdentifier,
            project: project,
            body: body,
            url: url,
            day: day,
            startsAt: startsAt,
            endsAt: endsAt,
            tag: tag)
    }
}
