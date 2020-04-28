//
//  UsedVacationCellModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol UsedVacationCellViewModelType: class {
    func configure()
}

protocol UsedVacationCellViewModelOutput: class {
    func setUp(type: String, days: String)
}

class UsedVacationCellViewModel {
    private weak var userInterface: UsedVacationCellViewModelOutput?
    private let type: UsedVacationViewModel.VacationType
    
    // MARK: - Initialization
    init(
        userInterface: UsedVacationCellViewModelOutput,
        type: UsedVacationViewModel.VacationType
    ) {
        self.userInterface = userInterface
        self.type = type
    }
}

// MARK: - UsedVacationCellModelType
extension UsedVacationCellViewModel: UsedVacationCellViewModelType {
    func configure() {
        self.userInterface?.setUp(
            type: self.type.loclizedString,
            days: R.string.localizable.days_key(days_key: self.type.days))
    }
}
