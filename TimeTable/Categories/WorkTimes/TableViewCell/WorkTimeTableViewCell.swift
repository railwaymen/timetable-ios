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
    @IBOutlet internal var projectViews: [UIView]!
    @IBOutlet internal var projectTitleLabel: UILabel!
    @IBOutlet internal var durationLabel: UILabel!
    @IBOutlet internal var bodyLabel: UILabel!
    @IBOutlet internal var fromToDateLabel: UILabel!
    
    private weak var viewModel: WorkTimeCellViewModelType?
    
    // MARK: - Overriden
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.prepareForReuse()
    }
    
    internal func update(durationText: String?, bodyText: String?, fromToDateText: String?, projectTitle: String?, projectColor: UIColor?) {
        self.fromToDateLabel.text = fromToDateText
        self.durationLabel.text = durationText
        self.bodyLabel.text = bodyText
        self.projectTitleLabel.text = projectTitle
        self.projectViews.forEach { $0.backgroundColor = projectColor }
    }
}

// MARK: - WorkTimeTableViewCellType
extension WorkTimeTableViewCell: WorkTimeTableViewCellType {
    func configure(viewModel: WorkTimeCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}
