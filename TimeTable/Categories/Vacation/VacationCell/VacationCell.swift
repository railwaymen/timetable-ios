//
//  VacationCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias VacationCellable = (VacationCellType & VacationCellViewModelOutput)

protocol VacationCellType: class {
    func configure(viewModel: VacationCellViewModelType)
}

class VacationCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var datesLabel: UILabel!
    @IBOutlet private var businessDaysLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    
    private var viewModel: VacationCellViewModelType!
}

// MARK: - VacationCellType
extension VacationCell: VacationCellType {
    func configure(viewModel: VacationCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel?.viewConfigured()
    }
}

// MARK: - VacationCellViewModelOutput
extension VacationCell: VacationCellViewModelOutput {
    func updateView(title: String, dates: String, businessDays: String, status: String, statusColor: UIColor) {
        self.titleLabel.text = title
        self.datesLabel.text = dates
        self.businessDaysLabel.text = businessDays
        self.statusLabel.text = status
        self.statusLabel.textColor = statusColor
    }
}
