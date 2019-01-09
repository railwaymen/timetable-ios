//
//  WorkTimeViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 09/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeViewModelOutput: class {
    
}

protocol WorkTimeViewModelType: class {
    
}

class WorkTimeViewModel: WorkTimeViewModelType {
    private weak var userInterface: WorkTimeViewModelOutput?
    
    // MARK: - Initialization
    init(userInterface: WorkTimeViewModelOutput?) {
        self.userInterface = userInterface
    }
}
