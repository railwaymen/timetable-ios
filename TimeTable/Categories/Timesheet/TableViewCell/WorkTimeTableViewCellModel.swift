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
    func updateEditionView(author: String?, date: String?)
    func updateBody(textParameters: LabelTextParameters)
    func updateProject(textParameters: LabelTextParameters, projectColor: UIColor?)
    func updateDayLabel(textParameters: LabelTextParameters)
    func updateFromToDateLabel(attributedText: NSAttributedString)
    func updateDuration(textParameters: LabelTextParameters)
    func updateTaskButton(titleParameters: ButtonTitleParameters)
    func updateTagView(text: String?, color: UIColor?)
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
    private struct ViewData {
        let durationParameters: LabelTextParameters
        let bodyParameters: LabelTextParameters
        let taskUrlParameters: ButtonTitleParameters
        let dayParameters: LabelTextParameters
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
        case day
        
        var taskVersionField: TaskVersion.Change {
            switch self {
            case .duration: return .duration
            case .body: return .body
            case .projectName: return .projectID
            case .task: return .task
            case .day: return .date
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
        self.userInterface?.updateEditionView(author: viewData.edition?.author, date: viewData.edition?.date)
        self.userInterface?.updateBody(textParameters: viewData.bodyParameters)
        self.userInterface?.updateProject(textParameters: viewData.projectTitleParameters, projectColor: viewData.projectColor)
        self.userInterface?.updateDayLabel(textParameters: viewData.dayParameters)
        self.userInterface?.updateFromToDateLabel(attributedText: viewData.fromToDateText)
        self.userInterface?.updateDuration(textParameters: viewData.durationParameters)
        self.userInterface?.updateTaskButton(titleParameters: viewData.taskUrlParameters)
        self.userInterface?.updateTagView(text: viewData.tagTitle, color: viewData.tagColor)
    }
    
    private func getViewData() -> ViewData {
        let editionData = self.getEditionData()
        let fromToDateText = self.getFromToDateString()
        return WorkTimeTableViewCellModel.ViewData(
            durationParameters: self.getLabelParameters(for: .duration),
            bodyParameters: self.getLabelParameters(for: .body),
            taskUrlParameters: self.getButtonParameters(for: .task),
            dayParameters: editionData == nil ? LabelTextParameters() : self.getLabelParameters(for: .day),
            fromToDateText: fromToDateText,
            projectTitleParameters: self.getLabelParameters(for: .projectName),
            projectColor: self.workTime.projectColor,
            tagTitle: self.workTime.tag.localized,
            tagColor: self.workTime.tag.color,
            edition: editionData)
    }
    
    private func getEditionData() -> (author: String, date: String)? {
        guard let author = self.workTime.updatedBy, let updatedAt = self.workTime.updatedAt else { return nil }
        let updatedAtText = self.updateAtDateFormatter.string(from: updatedAt)
        return (author, updatedAtText)
    }
    
    private func getFromToDateString() -> NSAttributedString {
        let startsAtText = self.timeFormatter.string(from: self.workTime.startsAt)
        let endsAtText = self.timeFormatter.string(from: self.workTime.endsAt)
        let startsAtAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: self.getColor(for: .startsAt) ?? .defaultLabel
        ]
        let delimiterAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.defaultSecondaryLabel
        ]
        let endsAtAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: self.getColor(for: .endsAt) ?? .defaultLabel
        ]
        let fromToDateText = NSMutableAttributedString()
        fromToDateText.append(NSAttributedString(string: startsAtText, attributes: startsAtAttributes))
        fromToDateText.append(NSAttributedString(string: " - ", attributes: delimiterAttributes))
        fromToDateText.append(NSAttributedString(string: endsAtText, attributes: endsAtAttributes))
        return fromToDateText
    }
    
    private func getLabelParameters(for label: ParameteredLabel) -> LabelTextParameters {
        return LabelTextParameters(
            text: self.getText(for: label),
            textColor: self.getColor(for: label.taskVersionField))
    }
    
    private func getButtonParameters(for label: ParameteredLabel) -> ButtonTitleParameters {
        return ButtonTitleParameters(
            title: self.getText(for: label),
            titleColor: self.getColor(for: label.taskVersionField))
    }
    
    private func getText(for label: ParameteredLabel) -> String? {
        switch label {
        case .projectName:
            return self.workTime.projectName
        case .body:
            return self.workTime.body
        case .duration:
            return DateComponentsFormatter.timeAbbreviated.string(from: self.workTime.duration)
        case .task:
            return self.workTime.taskPreview
        case .day:
            return DateFormatter.shortDate.string(from: self.workTime.startsAt)
        }
    }
    
    private func getColor(for field: TaskVersion.Change) -> UIColor? {
        guard self.workTime.event == .update else { return field.defaultColor }
        switch field {
        case .startsAt, .endsAt:
             return self.workTime.changedFields.contains(.date) ? field.defaultColor : .diffChanged
        default:
            return self.workTime.changedFields.contains(field) ? .diffChanged : field.defaultColor
        }
    }
}
