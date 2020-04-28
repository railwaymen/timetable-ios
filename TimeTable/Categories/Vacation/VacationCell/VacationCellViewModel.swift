//
//  VacationCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol VacationCellViewModelType: class {
    func viewConfigured()
}

protocol VacationCellViewModelOutput: class {
    func updateView(title: String, dates: String, businessDays: String, status: String, statusColor: UIColor)
}

class VacationCellViewModel {
    private weak var userInterface: VacationCellViewModelOutput?
    private var vacation: VacationResponse.Vacation
    
    // MARK: - Initialization
    init(
        userInterface: VacationCellViewModelOutput,
        vacation: VacationResponse.Vacation
    ) {
        self.userInterface = userInterface
        self.vacation = vacation
    }
}

// MARK: - VacationCellViewModelType
extension VacationCellViewModel: VacationCellViewModelType {
    func viewConfigured() {
        let startDate = DateFormatter.simple.string(from: self.vacation.startDate)
        let endDate = DateFormatter.simple.string(from: self.vacation.endDate)
        self.userInterface?.updateView(
            title: self.vacation.type.localizableString,
            dates: "\(startDate) - \(endDate)",
            businessDays: R.string.localizable.days_key(days_key: self.vacation.businessDaysCount),
            status: self.vacation.status.localizableString,
            statusColor: self.vacation.status.color)
    }
}
