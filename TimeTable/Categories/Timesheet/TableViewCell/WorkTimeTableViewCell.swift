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
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var fromToDateLabel: UILabel!
    @IBOutlet private var taskInfoVerticalStackView: UIStackView!
    @IBOutlet private var taskInfoHorizontalStackView: UIStackView!
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
    
    func updateEditionView(author: String?, date: String?) {
        let shouldBeHidden = author == nil && date == nil
        self.editionViewHeightConstraint.constant = 0
        self.editionViewHeightConstraint.isActive = shouldBeHidden
        self.editedByLabel.text = author
        self.updatedAtLabel.text = date
    }
    
    func updateBody(textParameters: LabelTextParameters) {
        self.bodyLabel.set(textParameters: textParameters)
    }
    
    func updateProject(textParameters: LabelTextParameters, projectColor: UIColor?) {
        self.projectTitleLabel.set(textParameters: textParameters)
        self.projectViews.forEach { $0.backgroundColor = projectColor }
    }
    
    func updateDayLabel(textParameters: LabelTextParameters) {
        self.dayLabel.set(textParameters: textParameters)
    }
    
    func updateFromToDateLabel(attributedText: NSAttributedString) {
        self.fromToDateLabel.attributedText = attributedText
    }
    
    func updateDuration(textParameters: LabelTextParameters) {
        self.durationLabel.set(textParameters: textParameters)
    }
    
    func updateTaskButton(titleParameters: ButtonTitleParameters) {
        self.taskButton.set(titleParameters: titleParameters)
        self.updateTaskInfoStackViews()
    }
    
    func updateTagView(text: String?, color: UIColor?) {
        self.tagView.set(isHidden: text == nil)
        self.tagLabel.text = text
        self.tagView.backgroundColor = color
        self.updateTaskInfoStackViews()
    }
}

// MARK: - WorkTimeTableViewCellType
extension WorkTimeTableViewCell: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeTableViewCellModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}

// MARK: - Private
extension WorkTimeTableViewCell {
    private func updateTaskInfoStackViews() {
        self.taskInfoVerticalStackView.setCustomSpacing(self.taskButton.isHidden ? 16 : 8, after: self.bodyLabel)
        self.taskInfoHorizontalStackView.set(isHidden: self.taskButton.isHidden && self.tagView.isHidden)
    }
}
