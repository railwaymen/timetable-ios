//
//  VacationsViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol VacationsViewModelOutput: class {
    func setUpView()
}

protocol VacationsViewModelType: class {
    func viewDidLoad()
    func viewRequestForProfileView()
}

class VacationsViewModel {
    private weak var userInterface: VacationsViewModelOutput?
    private weak var coordiantor: VacationsCoordinatorDelegate?
    
    // MARK: - Initialization
    init(
        userInterface: VacationsViewModelOutput?,
        coordiantor: VacationsCoordinatorDelegate?
    ) {
        self.userInterface = userInterface
        self.coordiantor = coordiantor
    }
}

// MARK: - VacationsViewModelType
extension VacationsViewModel: VacationsViewModelType {
    func viewDidLoad() {
        self.userInterface?.setUpView()
    }
    
    func viewRequestForProfileView() {
        self.coordiantor?.vacationsRequestedForProfileView()
    }
}
