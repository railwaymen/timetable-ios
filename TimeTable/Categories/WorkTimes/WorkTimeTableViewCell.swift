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
    @IBOutlet private var taskButton: UIButton!
    @IBOutlet private var fromToDateLabel: UILabel!
    
    private weak var viewModel: WorkTimeCellViewModelType?
    
    // MARK: - Overriden
    override func prepareForReuse() {
        viewModel?.prepareForReuse()
    }
    
    @IBAction private func taskButtonTapped(_ sender: UIButton) {
        viewModel?.viewRequestedForTaskPreview()
    }
}

// MARK: - WorkTimeCellViewModelOutput
extension WorkTimeTableViewCell: WorkTimeCellViewModelOutput {
    
}

// MARK: - WorkTimeTableViewCellType
extension WorkTimeTableViewCell: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeCellViewModelType) {
        self.viewModel = viewModel
    }
}
