//
//  RemoteWorkViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol RemoteWorkViewModelType: class {
    func loadView()
    func addNewRecordTapped()
    func profileButtonTapped()
}

protocol RemoteWorkViewModelOutput: class {
    func setUp()
}

class RemoteWorkViewModel {
    private weak var userInterface: RemoteWorkViewModelOutput?
    private weak var coordinator: RemoteWorkCoordinatorType?
    
    // MARK: - Initialization
    init(
        userInterface: RemoteWorkViewModelOutput,
        coordinator: RemoteWorkCoordinatorType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
    }
}

// MARK: - RemoteWorkViewModelType
extension RemoteWorkViewModel: RemoteWorkViewModelType {
    func loadView() {
        self.userInterface?.setUp()
    }
    
    func addNewRecordTapped() {
        self.coordinator?.remoteWorkDidRequestForFormView()
    }
    
    func profileButtonTapped() {
        self.coordinator?.remoteWorkDidRequestForProfileView()
    }
}
