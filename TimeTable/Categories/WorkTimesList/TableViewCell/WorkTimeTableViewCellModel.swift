//
//  WorkTimeTableViewCellModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol WorkTimeTableViewCellModelParentType: class {
    func openTask(for workTime: WorkTimeDecoder)
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
    private let workTime: WorkTimeDecoder
    private weak var userInterface: WorkTimeTableViewCellModelOutput?
    private weak var parent: WorkTimeTableViewCellModelParentType?
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    // MARK: - Initialization
    init(
        workTime: WorkTimeDecoder,
        userInterface: WorkTimeTableViewCellModelOutput,
        parent: WorkTimeTableViewCellModelParentType
    ) {
        self.workTime = workTime
        self.userInterface = userInterface
        self.parent = parent
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
        let duration = TimeInterval(self.workTime.duration)
        let durationText = self.dateComponentsFormatter.string(from: duration)
        let startsAtText = DateFormatter.localizedString(from: self.workTime.startsAt, dateStyle: .none, timeStyle: .short)
        let endsAtText = DateFormatter.localizedString(from: self.workTime.endsAt, dateStyle: .none, timeStyle: .short)
        let fromToDateText = "\(startsAtText) - \(endsAtText)"
        let data = WorkTimeTableViewCellModel.ViewData(
            durationText: durationText,
            bodyText: self.workTime.body,
            taskUrlText: self.workTime.taskPreview,
            fromToDateText: fromToDateText,
            projectTitle: self.workTime.project.name,
            projectColor: self.workTime.project.color,
            tagTitle: self.workTime.tag.localized,
            tagColor: self.workTime.tag.color)
        self.userInterface?.updateView(data: data)
    }
}
