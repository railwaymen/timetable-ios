//
//  VacationTableHeader.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias VacationTableHeaderViewable = (VacationTableHeaderViewModelOutput & VacationTableHeaderType)

protocol VacationTableHeaderType: class {
    func configure(viewModel: VacationTableHeaderViewModelType)
}

class VacationTableHeader: UITableViewHeaderFooterView, ReusableCellType {
    @IBOutlet private var daysLeft: UILabel!
    @IBOutlet private var yearTextField: UITextField!
    private var yearPickerView: YearPickerView!
    
    private var viewModel: VacationTableHeaderViewModelType!
    
    // MARK: - Actions
    @IBAction private func moreButtonTapped() {
        self.viewModel.moreButtonTapped()
    }
}

// MARK: - VacationTableHeaderViewModelOutput
extension VacationTableHeader: VacationTableHeaderViewModelOutput {
    func setUp() {
        self.yearPickerView = YearPickerView()
        self.yearPickerView.yearSelected = self.viewModel.yearSelected
        self.yearTextField.inputView = self.yearPickerView
    }
    
    func update(daysLeft: String) {
        self.daysLeft.text = daysLeft
    }
    
    func update(selectedYear: Int, stringValue: String) {
        self.yearPickerView.selectedYear = selectedYear
        self.yearTextField.text = stringValue
    }
}

// MARK: - VacationTableHeaderType
extension VacationTableHeader: VacationTableHeaderType {
    func configure(viewModel: VacationTableHeaderViewModelType) {
        self.viewModel = viewModel
        self.viewModel.setUp()
    }
}
