//
//  WorkTimeCellViewMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeCellViewMock: UITableViewCell {
    
    // MARK: - WorkTimeTableViewCellModelOutput
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {}
    
    private(set) var updateEditionViewParams: [UpdateEditionViewParams] = []
    struct UpdateEditionViewParams {
        let author: String?
        let date: String?
    }
    
    private(set) var updateBodyParams: [UpdateBodyParams] = []
    struct UpdateBodyParams {
        let textParameters: LabelTextParameters
    }
    
    private(set) var updateProjectParams: [UpdateProjectParams] = []
    struct UpdateProjectParams {
        let textParameters: LabelTextParameters
        let projectColor: UIColor?
    }
    
    private(set) var updateDayLabelParams: [UpdateDayLabelParams] = []
    struct UpdateDayLabelParams {
        let textParameters: LabelTextParameters
    }
    
    private(set) var updateFromToDateLabelParams: [UpdateFromToDateLabelParams] = []
    struct UpdateFromToDateLabelParams {
        let attributedText: NSAttributedString
    }
    
    private(set) var updateDurationParams: [UpdateDurationParams] = []
    struct UpdateDurationParams {
        let textParameters: LabelTextParameters
    }
    
    private(set) var updateTaskButtonParams: [UpdateTaskButtonParams] = []
    struct UpdateTaskButtonParams {
        let titleParameters: ButtonTitleParameters
    }
    
    private(set) var updateTagViewParams: [UpdateTagViewParams] = []
    struct UpdateTagViewParams {
        let text: String?
        let color: UIColor?
    }
    
    // MARK: - WorkTimeTableViewCellType
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: WorkTimeTableViewCellModelType
    }
}

// MARK: - WorkTimeTableViewCellModelOutput
extension WorkTimeCellViewMock: WorkTimeTableViewCellModelOutput {
    func setUp() {
        self.setUpParams.append(SetUpParams())
    }
    
    func updateEditionView(author: String?, date: String?) {
        self.updateEditionViewParams.append(UpdateEditionViewParams(author: author, date: date))
    }
    
    func updateBody(textParameters: LabelTextParameters) {
        self.updateBodyParams.append(UpdateBodyParams(textParameters: textParameters))
    }
    
    func updateProject(textParameters: LabelTextParameters, projectColor: UIColor?) {
        self.updateProjectParams.append(UpdateProjectParams(textParameters: textParameters, projectColor: projectColor))
    }
    
    func updateDayLabel(textParameters: LabelTextParameters) {
        self.updateDayLabelParams.append(UpdateDayLabelParams(textParameters: textParameters))
    }
    
    func updateFromToDateLabel(attributedText: NSAttributedString) {
        self.updateFromToDateLabelParams.append(UpdateFromToDateLabelParams(attributedText: attributedText))
    }
    
    func updateDuration(textParameters: LabelTextParameters) {
        self.updateDurationParams.append(UpdateDurationParams(textParameters: textParameters))
    }
    
    func updateTaskButton(titleParameters: ButtonTitleParameters) {
        self.updateTaskButtonParams.append(UpdateTaskButtonParams(titleParameters: titleParameters))
    }
    
    func updateTagView(text: String?, color: UIColor?) {
        self.updateTagViewParams.append(UpdateTagViewParams(text: text, color: color))
    }
}
    
// MARK: - WorkTimeTableViewCellType
extension WorkTimeCellViewMock: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeTableViewCellModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
