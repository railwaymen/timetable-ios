//
//  ServerConfigurationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ServerConfigurationViewModelOutput: class {
    func setUpView(serverAddress: String)
    func continueButtonEnabledState(_ isEnabled: Bool)
    func dismissKeyboard()
    func setActivityIndicator(isAnimating: Bool)
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState)
    func updateColors()
}

protocol ServerConfigurationViewModelType: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDisappear()
    func viewColorsShouldUpdate()
    func getCurrentKeyboardState() -> KeyboardManager.KeyboardState
    func continueButtonTapped()
    func serverAddressDidChange(text: String?)
    func serverAddressTextFieldDidRequestForReturn() -> Bool
    func viewTapped()
}

class ServerConfigurationViewModel: KeyboardManagerObserverable {
    private weak var userInterface: ServerConfigurationViewModelOutput?
    private weak var coordinator: ServerConfigurationCoordinatorDelegate?
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let errorHandler: ErrorHandlerType
    private let keyboardManager: KeyboardManagerable
    
    private var serverAddress: String?
    
    // MARK: - Initialization
    init(
        userInterface: ServerConfigurationViewModelOutput,
        coordinator: ServerConfigurationCoordinatorDelegate,
        serverConfigurationManager: ServerConfigurationManagerType,
        errorHandler: ErrorHandlerType,
        keyboardManager: KeyboardManagerable
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.serverConfigurationManager = serverConfigurationManager
        self.errorHandler = errorHandler
        self.keyboardManager = keyboardManager
    }
}

// MARK: - ServerSettingsViewModelType
extension ServerConfigurationViewModel: ServerConfigurationViewModelType {
    func viewDidLoad() {
        let oldConfiguration = self.serverConfigurationManager.getOldConfiguration()
        self.serverAddress = oldConfiguration?.host?.absoluteString
        self.userInterface?.setUpView(serverAddress: self.serverAddress ?? "")
    }
    
    func viewWillAppear() {
        self.keyboardManager.setKeyboardStateChangeHandler(for: self) { [weak userInterface] state in
            userInterface?.keyboardStateDidChange(to: state)
        }
        self.updateContinueButton()
    }
    
    func viewDidDisappear() {
        self.keyboardManager.removeHandler(for: self)
    }
    
    func viewColorsShouldUpdate() {
        self.userInterface?.updateColors()
    }
    
    func getCurrentKeyboardState() -> KeyboardManager.KeyboardState {
        self.keyboardManager.currentState
    }
    
    func continueButtonTapped() {
        guard let host = self.serverAddress,
            let hostURL = URL(string: host.apiSuffix().httpPrefix()) else {
            self.errorHandler.throwing(error: UIError.genericError)
            return
        }
        let configuration = ServerConfiguration(host: hostURL)
        self.userInterface?.setActivityIndicator(isAnimating: true)
        self.serverConfigurationManager.verify(configuration: configuration) { [weak self] result in
            self?.userInterface?.setActivityIndicator(isAnimating: false)
            switch result {
            case .success:
                self?.coordinator?.serverConfigurationDidFinish(with: configuration)
            case let .failure(error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func serverAddressDidChange(text: String?) {
        self.serverAddress = text
        self.updateContinueButton()
    }
    
    func serverAddressTextFieldDidRequestForReturn() -> Bool {
        self.userInterface?.dismissKeyboard()
        self.continueButtonTapped()
        return true
    }
    
    func viewTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - Private
extension ServerConfigurationViewModel {
    private func updateContinueButton() {
        self.userInterface?.continueButtonEnabledState(self.isServerURLValid())
    }
    
    private func isServerURLValid() -> Bool {
        guard let host = self.serverAddress else { return false }
        return URL(string: host) != nil
    }
}
