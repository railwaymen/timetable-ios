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
    private let errorHandler: ErrorHandlerType
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
    
    private let timeFormatter: DateFormatterType = DateFormatter.shortTime
    
    // MARK: - Initialization
    init(
        userInterface: WorkTimeTableViewCellModelOutput,
        parent: WorkTimeTableViewCellModelParentType,
        dateFormatterBuilder: DateFormatterBuilderType = DateFormatterBuilder(),
        errorHandler: ErrorHandlerType,
        workTime: WorkTimeDisplayed
    ) {
        self.userInterface = userInterface
        self.parent = parent
        self.dateFormatterBuilder = dateFormatterBuilder
        self.errorHandler = errorHandler
        self.workTime = workTime
    }
}

// MARK: - Structures
extension WorkTimeTableViewCellModel {
    struct ViewData {
        let durationParameters: LabelTextParameters
        let bodyParameters: LabelTextParameters
        let taskUrlParameters: LabelTextParameters
        let fromToDateText: NSAttributedString
        let projectTitleParameters: LabelTextParameters
        let projectColor: UIColor?
        let tagTitle: String?
        let tagColor: UIColor?
        let edition: (author: String, date: String)?
    }
    
    private enum ParameteredLabel {
        case duration
        case body
        case projectName
        case task
        
        var taskVersionField: TaskVersion.Field {
            switch self {
            case .duration: return .duration
            case .body: return .body
            case .projectName: return .projectName
            case .task: return .task
            }
        }
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
        let editionData = self.getEditionData()
        let fromToDateText = self.getFromToDateString()
        return WorkTimeTableViewCellModel.ViewData(
            durationParameters: self.getParameters(for: .duration),
            bodyParameters: self.getParameters(for: .body),
            taskUrlParameters: self.getParameters(for: .task),
            fromToDateText: fromToDateText,
            projectTitleParameters: self.getParameters(for: .projectName),
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
    
    private func getFromToDateString() -> NSAttributedString {
        let startsAtText = self.timeFormatter.string(from: self.workTime.startsAt)
        let endsAtText = self.timeFormatter.string(from: self.workTime.endsAt)
        let startsAtAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: self.getColor(for: .startsAt) ?? .defaultLabel]
        let delimiterAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.defaultSecondaryLabel]
        let endsAtAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: self.getColor(for: .endsAt) ?? .defaultLabel]
        let fromToDateText = NSMutableAttributedString()
        fromToDateText.append(NSAttributedString(string: startsAtText, attributes: startsAtAttributes))
        fromToDateText.append(NSAttributedString(string: " - ", attributes: delimiterAttributes))
        fromToDateText.append(NSAttributedString(string: endsAtText, attributes: endsAtAttributes))
        return fromToDateText
    }
    
    private func getParameters(for label: ParameteredLabel) -> LabelTextParameters {
        return LabelTextParameters(
            text: self.getText(for: label),
            textColor: self.getColor(for: label.taskVersionField))
    }
    
    private func getText(for label: ParameteredLabel) -> String? {
        switch label {
        case .projectName:
            return self.workTime.projectName
        case .body:
            return self.workTime.body
        case .duration:
            return self.dateComponentsFormatter.string(from: self.workTime.duration)
        case .task:
            return self.workTime.taskPreview
        }
    }
    
    private func getColor(for field: TaskVersion.Field) -> UIColor? {
        let defaultColor: UIColor
        switch field {
        case .body, .projectName:
            defaultColor = .defaultLabel
        case .duration, .startsAt, .endsAt, .task:
            defaultColor = .defaultSecondaryLabel
        case .tag:
            self.errorHandler.stopInDebug("There's no default color for tag and it's not expected to be needed.")
            return nil
        }
        return self.workTime.changedFields.contains(field) ? .diffChanged : defaultColor
    }
}
