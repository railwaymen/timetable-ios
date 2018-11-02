//
//  ServerConfigurationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ServerConfigurationViewModelOutput: class {
    func setupView(checkBoxIsActive: Bool)
    func tearDown()
    func hideNavigationBar()
    func continueButtonEnabledState(_ isEnabled: Bool)
    func checkBoxIsActiveState(_ isActive: Bool)
    func dissmissKeyboard()
}

protocol ServerConfigurationViewModelType: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewRequestedToContinue()
    func serverAddressDidChange(text: String?)
    func serverAddressTextFieldDidRequestForReturn() -> Bool
    func staySinedInCheckBoxStatusDidChange(isActive: Bool)
    func viewHasBeenTapped()
}

class ServerConfigurationViewModel: ServerConfigurationViewModelType {
    
    private weak var userInterface: ServerConfigurationViewModelOutput?
    private let coordinator: ServerConfigurationCoordinatorDelagete
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let errorHandler: ErrorHandlerType
    
    private var serverAddress: String?
    private var staySignedIn: Bool = true
    
    // MARK: - Life Cycle
    init(userInterface: ServerConfigurationViewModelOutput, coordinator: ServerConfigurationCoordinatorDelagete,
         serverConfigurationManager: ServerConfigurationManagerType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.serverConfigurationManager = serverConfigurationManager
        self.errorHandler = errorHandler
    }
    
    // MARK: - ServerSettingsViewModelType
    func viewDidLoad() {
        userInterface?.setupView(checkBoxIsActive: staySignedIn)
    }
    
    func viewWillAppear() {
        userInterface?.hideNavigationBar()
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
        let configuration = ServerConfiguration(host: hostURL, staySignedIn: staySignedIn)
        serverConfigurationManager.verify(configuration: configuration) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.coordinator.serverConfigurationDidFinish(with: configuration)
                }
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func serverAddressDidChange(text: String?) {
        serverAddress = text
        guard let host = serverAddress else { return }
        userInterface?.continueButtonEnabledState(URL(string: host) != nil)
    }
    
    func serverAddressTextFieldDidRequestForReturn() -> Bool {
        userInterface?.dissmissKeyboard()
        return true
    }
    
    func staySinedInCheckBoxStatusDidChange(isActive: Bool) {
        staySignedIn = !isActive
        userInterface?.checkBoxIsActiveState(!isActive)
    }
    
    func viewHasBeenTapped() {
        userInterface?.dissmissKeyboard()
    }
}
