//
//  VacationCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol VacationCellType: class {
    func configure(viewModel: VacationCellViewModelType)
}

class VacationCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var title: UILabel!
    @IBOutlet private var dates: UILabel!
    @IBOutlet private var businessDays: UILabel!
    @IBOutlet private var status: UILabel!
    
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
    func updateView(title: String, dates: String, businessDays: String, status: String) {
        self.title.text = title
        self.dates.text = dates
        self.businessDays.text = businessDays
        self.status.text = status
    }
}
