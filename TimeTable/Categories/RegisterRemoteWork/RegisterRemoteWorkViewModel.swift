//
//  RegisterRemoteWorkViewModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol RegisterRemoteWorkViewModelOutput: class {
    func setUp()
}

protocol RegisterRemoteWorkViewModelType: class {
    func loadView()
}

class RegisterRemoteWorkViewModel {
    private weak var userInterface: RegisterRemoteWorkViewModelOutput?
    private weak var coordinator: RegisterRemoteWorkCoordinatorType?
    
    // MARK: - Initialization
    init(
        userInterface: RegisterRemoteWorkViewModelOutput,
        coordinator: RegisterRemoteWorkCoordinatorType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
    }
}

// MARK: - RegisterRemoteWorkViewModelType
extension RegisterRemoteWorkViewModel: RegisterRemoteWorkViewModelType {
    func loadView() {
        self.userInterface?.setUp()
    }
}
