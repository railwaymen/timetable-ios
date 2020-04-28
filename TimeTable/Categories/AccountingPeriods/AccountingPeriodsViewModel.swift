//
//  AccountingPeriodsViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol AccountingPeriodsViewModelOutput: class {
    func setUp()
}

protocol AccountingPeriodsViewModelType: class {
    func viewDidLoad()
    func numberOfRows(in section: Int) -> Int
    func configure(_ cell: AccountingPeriodsCellConfigurationInterface, for indexPath: IndexPath)
}

class AccountingPeriodsViewModel {
    private weak var userInterface: AccountingPeriodsViewModelOutput?
    private weak var coordinator: AccountingPeriodsCoordinatorViewModelInterface?
    
    // MARK: - Initialization
    init(
        userInterface: AccountingPeriodsViewModelOutput,
        coordinator: AccountingPeriodsCoordinatorViewModelInterface?
     ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
    }
}

// MARK: - AccountingPeriodsViewModelType
extension AccountingPeriodsViewModel: AccountingPeriodsViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUp()
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 24
    }
    
    func configure(_ cell: AccountingPeriodsCellConfigurationInterface, for indexPath: IndexPath) {
        cell.configure(
            startsAt: "2020-04-01",
            endsAt: "2020-04-30",
            hours: "0.00/168",
            note: Bool.random() ? "Some Note\nHello" : "",
            isFullTime: Bool.random(),
            isClosed: Bool.random())
    }
}
