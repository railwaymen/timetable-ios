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
    func showList()
    func showErrorView()
}

protocol AccountingPeriodsViewModelType: class {
    func viewDidLoad()
    func numberOfRows(in section: Int) -> Int
    func configure(_ cell: AccountingPeriodsCellConfigurationInterface, for indexPath: IndexPath)
    func configure(_ errorView: ErrorViewable)
}

class AccountingPeriodsViewModel {
    private weak var userInterface: AccountingPeriodsViewModelOutput?
    private weak var coordinator: AccountingPeriodsCoordinatorViewModelInterface?
    
    private weak var errorViewModel: ErrorViewModelParentType?
    
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
        self.userInterface?.showErrorView()
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
    
    func configure(_ errorView: ErrorViewable) {
        self.errorViewModel = self.coordinator?.configure(errorView, refreshHandler: {
            // TODO: Fetch data
        })
    }
}
