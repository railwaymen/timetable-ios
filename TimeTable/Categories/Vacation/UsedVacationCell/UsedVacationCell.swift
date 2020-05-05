//
//  UsedVacationCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias UsedVacationCellable = (UsedVacationCellType & UsedVacationCellViewModelOutput)

protocol UsedVacationCellType: class {
    func configure(viewModel: UsedVacationCellViewModelType)
}

class UsedVacationCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var daysLabel: UILabel!

    private var viewModel: UsedVacationCellViewModelType!
}

// MARK: - UsedVacationCellViewModelOutput
extension UsedVacationCell: UsedVacationCellViewModelOutput {
    func setUp(type: String, days: String) {
        self.typeLabel.text = type
        self.daysLabel.text = days
    }
}

// MARK: - UsedVacationCellType
extension UsedVacationCell: UsedVacationCellType {
    func configure(viewModel: UsedVacationCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel.configure()
    }
}
