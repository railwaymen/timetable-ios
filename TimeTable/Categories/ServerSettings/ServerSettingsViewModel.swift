//
//  ServerSettingsViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ServerSettingsViewModelOutput: class {
    func setupView()
    func tearDown()
    func dissmissKeyboard()
}

protocol ServerSettingsViewModelType: class {
    func viewDidLoad()
    func viewWillDisappear()
    func viewRequestedToContinue()
    func serverAddressDidChange(text: String?)
    func viewHasBeenTapped()
}

class ServerSettingsViewModel: ServerSettingsViewModelType {
    
    private weak var userInterface: ServerSettingsViewModelOutput?
    
    // MARK: - Initialization
    init(userInterface: ServerSettingsViewModelOutput) {
        self.userInterface = userInterface
    }
    
    // MARK: - ServerSettingsViewModelType
    func viewDidLoad() {
        userInterface?.setupView()
    }
    
    func viewWillDisappear() {
        userInterface?.tearDown()
    }
    
    func viewRequestedToContinue() {
        
    }
    
    func serverAddressDidChange(text: String?) {
        
    }
    
    func viewHasBeenTapped() {
        userInterface?.dissmissKeyboard()
    }
}
