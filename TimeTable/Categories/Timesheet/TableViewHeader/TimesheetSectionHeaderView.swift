//
//  TimesheetSectionHeaderView.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol TimesheetSectionHeaderViewType: class {
    func configure(viewModel: TimesheetSectionHeaderViewModelType)
}

class TimesheetSectionHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooterView {
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var summaryLabel: UILabel!
    
    private var viewModel: TimesheetSectionHeaderViewModelType!
}

// MARK: - TimesheetSectionHeaderViewModelOutput
extension TimesheetSectionHeaderView: TimesheetSectionHeaderViewModelOutput {
    func updateView(dayText: String?, durationText: String?) {
        self.dayLabel.text = dayText
        self.summaryLabel.text = durationText
    }
}

// MARK: - TimesheetSectionHeaderViewType
extension TimesheetSectionHeaderView: TimesheetSectionHeaderViewType {
    func configure(viewModel: TimesheetSectionHeaderViewModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}
