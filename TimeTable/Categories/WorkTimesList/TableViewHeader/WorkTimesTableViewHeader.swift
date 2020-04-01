//
//  WorkTimesTableViewHeader.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias WorkTimesTableViewHeaderable = (
    UITableViewHeaderFooterView
    & WorkTimesTableViewHeaderViewModelOutput
    & WorkTimesTableViewHeaderType)

protocol WorkTimesTableViewHeaderType: class {
    func configure(viewModel: WorkTimesTableViewHeaderViewModelType)
}

class WorkTimesTableViewHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = "WorkTimesTableViewHeaderIdentifier"
    
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var summaryLabel: UILabel!
    
    private var viewModel: WorkTimesTableViewHeaderViewModelType!
}

// MARK: - WorkTimesTableViewHeaderViewModelOutput
extension WorkTimesTableViewHeader: WorkTimesTableViewHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {
        self.dayLabel.text = dayText
        self.summaryLabel.text = durationText
    }
}

// MARK: - WorkTimesTableViewHeaderType
extension WorkTimesTableViewHeader: WorkTimesTableViewHeaderType {
    func configure(viewModel: WorkTimesTableViewHeaderViewModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}
