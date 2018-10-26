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
    func continueButtonEnabledState(_ isEnabled: Bool)
}

protocol ServerSettingsViewModelType: class {
    func viewDidLoad()
    func viewWillDisappear()
    func viewRequestedToContinue()
    func serverAddressDidChange(text: String?)
    func serverAddressTextFieldDidRequestForReturn() -> Bool
    func viewHasBeenTapped()
}

class ServerSettingsViewModel: ServerSettingsViewModelType {
    
    private weak var userInterface: ServerSettingsViewModelOutput?
    private let errorHandler: ErrorHandlerType
    
    private var serverAddress: String?
    
    // MARK: - Initialization
    init(userInterface: ServerSettingsViewModelOutput, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.errorHandler = errorHandler
    }
    
    // MARK: - ServerSettingsViewModelType
    func viewDidLoad() {
        userInterface?.setupView()
    }
    
    func viewWillDisappear() {
        userInterface?.tearDown()
    }
    
    func viewRequestedToContinue() {
        guard let host = serverAddress else {
            errorHandler.throwing(error: UIError.cannotBeEmpty(.serverAddressTextField))
            return
        }
        guard let hostURL = URL(string: host) else {
            errorHandler.throwing(error: UIError.invalidFormat(.serverAddressTextField))
            return
        }
        print(hostURL)
    }
    
    func serverAddressDidChange(text: String?) {
        serverAddress = text
        if let host = text {
            userInterface?.continueButtonEnabledState(URL(string: host) != nil)
        }
    }
    
    func serverAddressTextFieldDidRequestForReturn() -> Bool {
        userInterface?.dissmissKeyboard()
        return true
    }
    
    func viewHasBeenTapped() {
        userInterface?.dissmissKeyboard()
    }
}
