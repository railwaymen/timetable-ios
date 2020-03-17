//
//  WorkTimeTableViewCellModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol WorkTimeTableViewCellModelParentType: class {
    func openTask(for workTime: WorkTimeDisplayed)
}

protocol WorkTimeTableViewCellModelOutput: class {
    func setUp()
    func updateView(data: WorkTimeTableViewCellModel.ViewData)
}

protocol WorkTimeTableViewCellModelType: class {
    func viewConfigured()
    func prepareForReuse()
    func taskButtonTapped()
}

class WorkTimeTableViewCellModel {
    private weak var userInterface: WorkTimeTableViewCellModelOutput?
    private weak var parent: WorkTimeTableViewCellModelParentType?
    private let dateFormatterBuilder: DateFormatterBuilderType
    private let workTime: WorkTimeDisplayed
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    private var updateAtDateFormatter: DateFormatterType {
        self.dateFormatterBuilder
            .dateStyle(.long)
            .timeStyle(.short)
            .setRelativeDateFormatting(true)
            .build()
    }
    
    private var timeFormatter: DateFormatterType {
        self.dateFormatterBuilder
            .timeStyle(.short)
            .build()
    }
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimeTableViewCellModelOutput,
        parent: WorkTimeTableViewCellModelParentType,
        dateFormatterBuilder: DateFormatterBuilderType = DateFormatterBuilder(),
        workTime: WorkTimeDisplayed
    ) {
        self.userInterface = userInterface
        self.parent = parent
        self.dateFormatterBuilder = dateFormatterBuilder
        self.workTime = workTime
    }
}

// MARK: - Structures
extension WorkTimeTableViewCellModel {
    struct ViewData {
        let durationText: String?
        let bodyText: String?
        let taskUrlText: String?
        let fromToDateText: String?
        let projectTitle: String?
        let projectColor: UIColor?
        let tagTitle: String?
        let tagColor: UIColor?
        let edition: (author: String, date: String)?
    }
}

// MARK: - WorkTimeTableViewCellModelType
extension WorkTimeTableViewCellModel: WorkTimeTableViewCellModelType {
    func viewConfigured() {
        self.userInterface?.setUp()
        self.updateView()
    }
    
    func prepareForReuse() {
        self.updateView()
    }
    
    func taskButtonTapped() {
        self.parent?.openTask(for: self.workTime)
    }
}

// MARK: - Private
extension WorkTimeTableViewCellModel {
    private func updateView() {
        let viewData = self.getViewData()
        self.userInterface?.updateView(data: viewData)
    }
    
    private func getViewData() -> ViewData {
        let durationText = self.dateComponentsFormatter.string(from: self.workTime.duration)
        let startsAtText = self.timeFormatter.string(from: self.workTime.startsAt)
        let endsAtText = self.timeFormatter.string(from: self.workTime.endsAt)
        let fromToDateText = "\(startsAtText) - \(endsAtText)"
        let editionData = self.getEditionData()
        return WorkTimeTableViewCellModel.ViewData(
            durationText: durationText,
            bodyText: self.workTime.body,
            taskUrlText: self.workTime.taskPreview,
            fromToDateText: fromToDateText,
            projectTitle: self.workTime.projectName,
            projectColor: self.workTime.projectColor,
            tagTitle: self.workTime.tag.localized,
            tagColor: self.workTime.tag.color,
            edition: editionData)
    }
    
    private func getEditionData() -> (String, String)? {
        guard let author = self.workTime.updatedBy, let updatedAt = self.workTime.updatedAt else { return nil }
        let updatedAtText = self.updateAtDateFormatter.string(from: updatedAt)
        return (author, updatedAtText)
    }
}
