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
    @IBOutlet private var projectViews: [UIView]!
    @IBOutlet private var projectTitleLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var fromToDateLabel: UILabel!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var taskButton: UIButton!
    @IBOutlet private var tagView: AttributedView!
    @IBOutlet private var tagLabel: UILabel!
    
    private weak var viewModel: WorkTimeCellViewModelType?
    
    // MARK: - Overriden
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel?.prepareForReuse()
    }
    
    // MARK: - IBAction
    @IBAction private func taskButtonTapped(_ sender: UIButton) {
        // TO_DO: - redirect to task preview
    }
}

// MARK: - WorkTimeCellViewModelOutput
extension WorkTimeTableViewCell: WorkTimeCellViewModelOutput {
    func updateView(data: WorkTimeCellViewModel.ViewData) {
        self.fromToDateLabel.text = data.fromToDateText
        self.durationLabel.text = data.durationText
        self.bodyLabel.text = data.bodyText
        self.projectTitleLabel.text = data.projectTitle
        self.projectViews.forEach { $0.backgroundColor = data.projectColor }
        self.taskButton.isHidden = data.taskUrlText == nil
        self.taskButton?.setTitle(data.taskUrlText, for: .normal)
        self.tagView.isHidden = data.tagTitle == nil
        self.tagLabel.text = data.tagTitle
        self.tagView.backgroundColor = data.tagColor
        self.stackView.setCustomSpacing(16, after: self.taskButton)
        self.stackView.setCustomSpacing(self.taskButton.isHidden ? 16 : 8, after: self.bodyLabel)
    }
}

// MARK: - WorkTimeTableViewCellType
extension WorkTimeTableViewCell: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}
