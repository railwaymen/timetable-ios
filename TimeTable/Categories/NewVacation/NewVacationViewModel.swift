//
//  NewVacationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol NewVacationViewModelType: class {
    func loadView()
}

protocol NewVacationViewModelOutput: class {
    
}

class NewVacationViewModel {
    private weak var userInterface: NewVacationViewModelOutput?
    private weak var coordinator: NewVacationCoordinatorDelegate?
    private let apiClient: ApiClientVacationType
    private let errorHandler: ErrorHandlerType
    
    // MARK: - Initialization
    init(
        userInterface: NewVacationViewModelOutput,
        apiClient: ApiClientVacationType,
        errorHandler: ErrorHandlerType,
        coordinator: NewVacationCoordinatorDelegate
    ) {
        self.userInterface = userInterface
        self.apiClient = apiClient
        self.errorHandler = errorHandler
        self.coordinator = coordinator
    }
}

// MARK: - NewVacationViewModelType
extension NewVacationViewModel: NewVacationViewModelType {
    func loadView() {
        
    }
}
