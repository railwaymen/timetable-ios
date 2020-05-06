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
}

protocol RemoteWorkViewModelOutput: class {}

class RemoteWorkViewModel {
    private weak var userInterface: RemoteWorkViewModelOutput?
    
    // MARK: - Initialization
    init(userInterface: RemoteWorkViewModelOutput) {
        self.userInterface = userInterface
    }
}

// MARK: - RemoteWorkViewModelType
extension RemoteWorkViewModel: RemoteWorkViewModelType {
    func loadView() {
        
    }
}
