//
//  UsedVacationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 28/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol UsedVacationViewModelOutput: class {
    func setUp(title: String)
}

protocol UsedVacationViewModelType: class {
    func viewDidLoad()
    func closeButtonTapped()
    func numberOfItems() -> Int
    func configure(_ cell: UsedVacationCellable, for indexPath: IndexPath)
}

class UsedVacationViewModel {
    private weak var userInterface: UsedVacationViewModelOutput?
    private weak var coordinator: UsedVacationCoordinatorDelegate?
    private let usedDays: UsedDays
    
    // MARK: - Initialization
    init(
        userInterface: UsedVacationViewModelOutput,
        coordinator: UsedVacationCoordinatorDelegate,
        usedDays: VacationResponse.UsedVacationDays
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.usedDays = UsedDays(usedDays: usedDays)
    }
}

// MARK: - Structures
extension UsedVacationViewModel {
    struct VacationType {
        let loclizedString: String
        let days: Int
    }
    
    struct UsedDays {
        let types: [VacationType]
        
        // MARK: - Initialization
        init(usedDays: VacationResponse.UsedVacationDays) {
            self.types = [
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_planned(),
                    days: usedDays.planned),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_requested(),
                    days: usedDays.requested),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_compassionate(),
                    days: usedDays.compassionate),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_paternity(),
                    days: usedDays.paternity),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_parental(),
                    days: usedDays.parental),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_upbringing(),
                    days: usedDays.upbringing),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_unpaid(),
                    days: usedDays.unpaid),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_rehabilitation(),
                    days: usedDays.rehabilitation),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_illness(),
                    days: usedDays.illness),
                VacationType(
                    loclizedString: R.string.localizable.vacation_type_care(),
                    days: usedDays.care)
            ]
        }
    }
}

// MARK: - UsedVacationViewModelType
extension UsedVacationViewModel: UsedVacationViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp(title: R.string.localizable.vacation_used_days_title())
    }
    
    func closeButtonTapped() {
        self.coordinator?.usedVacationRequestToFinish()
    }
    
    func numberOfItems() -> Int {
        return self.usedDays.types.count
    }
    
    func configure(_ cell: UsedVacationCellable, for indexPath: IndexPath) {
        guard let type = self.usedDays.types[safeIndex: indexPath.row] else { return }
        let viewModel = UsedVacationCellViewModel(userInterface: cell, type: type)
        cell.configure(viewModel: viewModel)
    }
}
