//
//  RemoteWorkCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol RemoteWorkCellViewModelType: class {
    func viewConfigured()
}

protocol RemoteWorkCellViewModelOutput: class {
    
}

class RemoteWorkCellViewModel {
    private weak var userInterface: RemoteWorkCellViewModelOutput?
    private let remoteWork: RemoteWork
    
    // MARK: - Initialization
    init(
        userInterface: RemoteWorkCellViewModelOutput,
        remoteWork: RemoteWork
    ) {
        self.userInterface = userInterface
        self.remoteWork = remoteWork
    }
}

// MARK: - RemoteWorkCellViewModelType
extension RemoteWorkCellViewModel: RemoteWorkCellViewModelType {
    func viewConfigured() {
        
    }
}
