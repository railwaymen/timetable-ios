//
//  VacationTableHeaderViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol VacationTableHeaderViewModelable: class {
    var availableVacationDays: Int { get set }
}

protocol VacationTableHeaderViewModelType: class {
    func setUp()
    func moreButtonTapped()
    func yearSelected(_ year: Int)
}

protocol VacationTableHeaderViewModelOutput: class {
    func setUp()
    func update(daysLeft: String)
    func update(selectedYear: Int, stringValue: String)
}

class VacationTableHeaderViewModel: VacationTableHeaderViewModelable {
    private weak var userInterface: VacationTableHeaderViewModelOutput?
    private var onYearSelection: ((_ year: Int) -> Void)?
    private var onMoreInfoSelection: (() -> Void)?
    private var selectedYear: Int {
        didSet {
            self.userInterface?.update(
                selectedYear: self.selectedYear,
                stringValue: "\(self.selectedYear)")
        }
    }
    var availableVacationDays: Int {
        didSet {
            self.userInterface?.update(daysLeft: "\(self.availableVacationDays)")
        }
    }
    
    // MARK: - Initialization
    init(
        userInterface: VacationTableHeaderViewModelOutput,
        availableVacationDays: Int,
        selectedYear: Int,
        onYearSelection: ((_ year: Int) -> Void)?,
        onMoreInfoSelection: (() -> Void)?
    ) {
        self.userInterface = userInterface
        self.selectedYear = selectedYear
        self.availableVacationDays = availableVacationDays
        self.onYearSelection = onYearSelection
        self.onMoreInfoSelection = onMoreInfoSelection
    }
}

// MARK: - VacationTableHeaderViewModelType
extension VacationTableHeaderViewModel: VacationTableHeaderViewModelType {
    func setUp() {
        self.userInterface?.setUp()
        self.userInterface?.update(daysLeft: "\(self.availableVacationDays)")
        self.userInterface?.update(selectedYear: self.selectedYear, stringValue: "\(self.selectedYear)")
    }
    
    func moreButtonTapped() {
        self.onMoreInfoSelection?()
    }
    
    func yearSelected(_ year: Int) {
        self.selectedYear = year
        self.onYearSelection?(year)
    }
}
