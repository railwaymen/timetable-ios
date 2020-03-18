//
//  WorkTimeTableViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimeTableViewCellable = (UITableViewCell & WorkTimeTableViewCellType & WorkTimeTableViewCellModelOutput)

protocol WorkTimeTableViewCellType: class {
    func configure(viewModel: WorkTimeTableViewCellModelType)
}

class WorkTimeTableViewCell: UITableViewCell, ReusableCellType {    
    @IBOutlet private var shadowView: UIView!
    @IBOutlet private var roundedContainerView: AttributedView!
    @IBOutlet private var projectViews: [UIView]!
    @IBOutlet private var projectTitleLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var fromToDateLabel: UILabel!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var taskButton: UIButton!
    @IBOutlet private var tagView: AttributedView!
    @IBOutlet private var tagLabel: UILabel!
    @IBOutlet private var editedByLabel: UILabel!
    @IBOutlet private var updatedAtLabel: UILabel!
    @IBOutlet private var editionViewHeightConstraint: NSLayoutConstraint!
    
    private var viewModel: WorkTimeTableViewCellModelType?
    
    // MARK: - Overridden
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel?.prepareForReuse()
    }
    
    // MARK: - Actions
    @IBAction private func taskButtonTapped(_ sender: UIButton) {
        self.viewModel?.taskButtonTapped()
    }
}

// MARK: - WorkTimeTableViewCellModelOutput
extension WorkTimeTableViewCell: WorkTimeTableViewCellModelOutput {
    func setUp() {
        self.shadowView.layer.shadowRadius = 4
        self.shadowView.layer.shadowColor = UIColor.defaultLabel.withAlphaComponent(0.07).cgColor
        self.shadowView.layer.shadowOpacity = 1
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowView.layer.cornerRadius = self.roundedContainerView.cornerRadius
    }
    
    func updateView(data: WorkTimeTableViewCellModel.ViewData) {
        self.editionViewHeightConstraint.constant = 0
        self.editionViewHeightConstraint.isActive = data.edition == nil
        self.editedByLabel.text = data.edition?.author
        self.updatedAtLabel.text = data.edition?.date
        self.fromToDateLabel.text = data.fromToDateText
        self.durationLabel.text = data.durationText
        self.bodyLabel.text = data.bodyText
        self.projectTitleLabel.text = data.projectTitle
        self.projectViews.forEach { $0.backgroundColor = data.projectColor }
        self.taskButton.set(isHidden: data.taskUrlText == nil)
        self.taskButton?.setTitle(data.taskUrlText, for: .normal)
        self.tagView.set(isHidden: data.tagTitle == nil)
        self.tagLabel.text = data.tagTitle
        self.tagView.backgroundColor = data.tagColor
        self.stackView.setCustomSpacing(16, after: self.taskButton)
        self.stackView.setCustomSpacing(self.taskButton.isHidden ? 16 : 8, after: self.bodyLabel)
    }
}

// MARK: - WorkTimeTableViewCellType
extension WorkTimeTableViewCell: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeTableViewCellModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}
