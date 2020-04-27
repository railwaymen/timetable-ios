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
}
