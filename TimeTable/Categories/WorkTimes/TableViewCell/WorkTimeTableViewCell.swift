//
//  WorkTimeTableViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimeTableViewCellalbe = (UITableViewCell & WorkTimeTableViewCellType & WorkTimeCellViewModelOutput)

protocol WorkTimeTableViewCellType: class {
    func configure(viewModel: WorkTimeCellViewModelType)
}

class WorkTimeTableViewCell: UITableViewCell {

    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var taskButton: UIButton?
    @IBOutlet private var fromToDateLabel: UILabel!
    @IBOutlet private var projectView: ProjectView!
    
    private weak var viewModel: WorkTimeCellViewModelType?
    
    // MARK: - Overriden
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.prepareForReuse()
    }
    
    // MARK: - IBAction
    @IBAction private func taskButtonTapped(_ sender: UIButton) {
        // TO_DO: - redirect to task preview 
    }
}

// MARK: - WorkTimeCellViewModelOutput
extension WorkTimeTableViewCell: WorkTimeCellViewModelOutput {
    func updateView(durationText: String?, bodyText: String?, taskText: String?, fromToDateText: String?, projectData: ProjectView.ProjectData) {
        self.durationLabel.text = durationText
        self.bodyLabel.text = bodyText
        if let taskText = taskText {
            self.taskButton?.setTitle(taskText, for: .normal)
        } else {
            self.taskButton?.removeFromSuperview()
        }
        fromToDateLabel.text = fromToDateText
        projectView.setUp(data: projectData)
    }
}

// MARK: - WorkTimeTableViewCellType
extension WorkTimeTableViewCell: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}
