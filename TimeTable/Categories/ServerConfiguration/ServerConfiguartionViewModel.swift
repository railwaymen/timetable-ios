//
//  ServerConfigurationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ServerConfigurationViewModelOutput: class {
    func setupView(checkBoxIsActive: Bool, serverAddress: String)
    func continueButtonEnabledState(_ isEnabled: Bool)
    func checkBoxIsActiveState(_ isActive: Bool)
    func dismissKeyboard()
    func setActivityIndicator(isHidden: Bool)
}

protocol ServerConfigurationViewModelType: class {
    func viewDidLoad()
    func viewRequestedToContinue()
    func serverAddressDidChange(text: String?)
    func serverAddressTextFieldDidRequestForReturn() -> Bool
    func shouldRemeberHostCheckBoxStatusDidChange(isActive: Bool)
    func viewHasBeenTapped()
}

class ServerConfigurationViewModel: ServerConfigurationViewModelType {
    private weak var userInterface: ServerConfigurationViewModelOutput?
    private let coordinator: ServerConfigurationCoordinatorDelegate
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let errorHandler: ErrorHandlerType
    
    private var serverAddress: String?
    private var shouldRememberHost: Bool = true
    
    // MARK: - Initialization
    init(userInterface: ServerConfigurationViewModelOutput, coordinator: ServerConfigurationCoordinatorDelegate,
         serverConfigurationManager: ServerConfigurationManagerType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.serverConfigurationManager = serverConfigurationManager
        self.errorHandler = errorHandler
    }
    
    // MARK: - ServerSettingsViewModelType
    func viewDidLoad() {
        let oldConfiguration = self.serverConfigurationManager.getOldConfiguration()
        self.serverAddress = oldConfiguration?.host?.absoluteString
        self.shouldRememberHost = oldConfiguration?.shouldRememberHost ?? true
        self.userInterface?.setupView(checkBoxIsActive: self.shouldRememberHost, serverAddress: self.serverAddress ?? "")
    }
    
    func viewRequestedToContinue() {
        guard let host = self.serverAddress else {
            self.errorHandler.throwing(error: UIError.cannotBeEmpty(.serverAddressTextField))
            return
        }
        guard let hostURL = URL(string: host.apiSuffix().httpPrefix()) else {
            self.errorHandler.throwing(error: UIError.invalidFormat(.serverAddressTextField))
            return
        }
        let configuration = ServerConfiguration(host: hostURL, shouldRememberHost: self.shouldRememberHost)
        self.userInterface?.setActivityIndicator(isHidden: false)
        self.serverConfigurationManager.verify(configuration: configuration) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isHidden: true)
            switch result {
            case .success:
                self?.coordinator.serverConfigurationDidFinish(with: configuration)
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func serverAddressDidChange(text: String?) {
        self.serverAddress = text
        guard let host = self.serverAddress else { return }
        self.userInterface?.continueButtonEnabledState(URL(string: host) != nil)
    }
    
    func serverAddressTextFieldDidRequestForReturn() -> Bool {
        self.userInterface?.dismissKeyboard()
        return true
    }
    
    func shouldRemeberHostCheckBoxStatusDidChange(isActive: Bool) {
        self.shouldRememberHost = !isActive
        self.userInterface?.checkBoxIsActiveState(!isActive)
    }
    
    func viewHasBeenTapped() {
        self.userInterface?.dismissKeyboard()
    }
}
