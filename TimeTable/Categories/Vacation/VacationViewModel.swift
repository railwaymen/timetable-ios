//
//  VacationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol VacationViewModelOutput: class {
    func setUpView()
}

protocol VacationViewModelType: class {
    func viewDidLoad()
    func viewRequestForProfileView()
}

class VacationViewModel {
    private weak var userInterface: VacationViewModelOutput?
    private weak var coordinator: VacationCoordinatorDelegate?
    
    // MARK: - Initialization
    init(
        userInterface: VacationViewModelOutput,
        coordinator: VacationCoordinatorDelegate
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
    }
}

// MARK: - VacationViewModelType
extension VacationViewModel: VacationViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUpView()
    }
    
    func viewRequestForProfileView() {
        self.coordinator?.vacationRequestedForProfileView()
    }
}
