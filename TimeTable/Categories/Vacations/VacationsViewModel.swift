//
//  VacationsViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol VacationsViewModelOutput: class {
    
}

protocol VacationsViewModelType: class {
    
}

class VacationsViewModel {
    private weak var userInterface: VacationsViewModelOutput?
    
    // MARK: - Initialization
    init(userInterface: VacationsViewModelOutput?) {
        self.userInterface = userInterface
    }
}

// MARK: - VacationsViewModelType
extension VacationsViewModel: VacationsViewModelType {
    
}
