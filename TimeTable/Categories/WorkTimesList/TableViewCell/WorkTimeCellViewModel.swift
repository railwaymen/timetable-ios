//
//  WorkTimesCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol WorkTimeCellViewModelParentType: class {
    func openTask(for workTime: WorkTimeDecoder)
}

protocol WorkTimeCellViewModelOutput: class {
    func setUp()
    func updateView(data: WorkTimeCellViewModel.ViewData)
}

protocol WorkTimeCellViewModelType: class {
    func viewConfigured()
    func prepareForReuse()
    func taskButtonTapped()
}

class WorkTimeCellViewModel: WorkTimeCellViewModelType {

    private let workTime: WorkTimeDecoder
    private weak var userInterface: WorkTimeCellViewModelOutput?
    private weak var parent: WorkTimeCellViewModelParentType?
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    // MARK: - Initialization
    init(workTime: WorkTimeDecoder, userInterface: WorkTimeCellViewModelOutput, parent: WorkTimeCellViewModelParentType) {
        self.workTime = workTime
        self.userInterface = userInterface
        self.parent = parent
    }
    
    // MARK: - WorkTimeCellViewModelType
    func viewConfigured() {
        userInterface?.setUp()
        updateView()
    }
    
    func prepareForReuse() {
        updateView()
    }
    
    func taskButtonTapped() {
        parent?.openTask(for: workTime)
    }
    
    // MARK: - Private
    private func updateView() {
        let duration = TimeInterval(workTime.duration)
        let durationText = dateComponentsFormatter.string(from: duration)
        let startsAtText = DateFormatter.localizedString(from: workTime.startsAt, dateStyle: .none, timeStyle: .short)
        let endsAtText = DateFormatter.localizedString(from: workTime.endsAt, dateStyle: .none, timeStyle: .short)
        let fromToDateText = "\(startsAtText) - \(endsAtText)"
        let data = WorkTimeCellViewModel.ViewData(durationText: durationText,
                                                  bodyText: workTime.body,
                                                  taskUrlText: workTime.taskPreview,
                                                  fromToDateText: fromToDateText,
                                                  projectTitle: workTime.project.name,
                                                  projectColor: workTime.project.color,
                                                  tagTitle: workTime.tag.localized,
                                                  tagColor: workTime.tag.color)
        userInterface?.updateView(data: data)
    }
    
    // MARK: - Structures
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
