//
//  VacationCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol VacationCellViewModelType: class {
    func viewConfigured()
}

protocol VacationCellViewModelOutput: class {
    func updateView(title: String, dates: String, businessDays: String, status: String)
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
            title: self.vacation.type.rawValue,
            dates: "\(startDate)-\(endDate)",
            businessDays: "\(self.vacation.businessDaysCount) days",
            status: self.vacation.status.rawValue)
    }
}
