//
//  ServerConfigurationViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ServerConfigurationViewModelOutput: class {
    func setUpView(checkBoxIsActive: Bool, serverAddress: String)
    func continueButtonEnabledState(_ isEnabled: Bool)
    func checkBoxIsActiveState(_ isActive: Bool)
    func dismissKeyboard()
    func setActivityIndicator(isHidden: Bool)
    func setBottomContentInset(_ height: CGFloat)
}

protocol ServerConfigurationViewModelType: class {
    func viewDidLoad()
    func continueButtonTapped()
    func serverAddressDidChange(text: String?)
    func serverAddressTextFieldDidRequestForReturn() -> Bool
    func checkboxButtonTapped(isActive: Bool)
    func viewTapped()
}

class ServerConfigurationViewModel {
    private weak var userInterface: ServerConfigurationViewModelOutput?
    private let coordinator: ServerConfigurationCoordinatorDelegate
    private let serverConfigurationManager: ServerConfigurationManagerType
    private let errorHandler: ErrorHandlerType
    private let notificationCenter: NotificationCenterType
    
    private var serverAddress: String?
    private var shouldRememberHost: Bool = true
    
    // MARK: - Initialization
    init(
        userInterface: ServerConfigurationViewModelOutput,
        coordinator: ServerConfigurationCoordinatorDelegate,
        serverConfigurationManager: ServerConfigurationManagerType,
        errorHandler: ErrorHandlerType,
        notificationCenter: NotificationCenterType
    ) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.serverConfigurationManager = serverConfigurationManager
        self.errorHandler = errorHandler
        self.notificationCenter = notificationCenter
        self.setUpNotifications()
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notification
    @objc func changeKeyboardFrame(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        self.userInterface?.setBottomContentInset(keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        self.userInterface?.setBottomContentInset(0)
    }
}

// MARK: - ServerSettingsViewModelType
extension ServerConfigurationViewModel: ServerConfigurationViewModelType {
    func viewDidLoad() {
        let oldConfiguration = self.serverConfigurationManager.getOldConfiguration()
        self.serverAddress = oldConfiguration?.host?.absoluteString
        self.shouldRememberHost = oldConfiguration?.shouldRememberHost ?? true
        self.userInterface?.setUpView(checkBoxIsActive: self.shouldRememberHost, serverAddress: self.serverAddress ?? "")
        self.updateContinueButton()
    }
    
    func continueButtonTapped() {
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
        self.updateContinueButton()
    }
    
    func serverAddressTextFieldDidRequestForReturn() -> Bool {
        self.userInterface?.dismissKeyboard()
        self.continueButtonTapped()
        return true
    }
    
    func checkboxButtonTapped(isActive: Bool) {
        self.shouldRememberHost = !isActive
        self.userInterface?.checkBoxIsActiveState(!isActive)
    }
    
    func viewTapped() {
        self.userInterface?.dismissKeyboard()
    }
}

// MARK: - Private
extension ServerConfigurationViewModel {
    private func setUpNotifications() {
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        self.notificationCenter.addObserver(
            self,
            selector: #selector(self.changeKeyboardFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    private func updateContinueButton() {
        self.userInterface?.continueButtonEnabledState(self.isServerURLValid())
    }
    
    private func isServerURLValid() -> Bool {
        guard let host = self.serverAddress else { return false }
        return URL(string: host) != nil
    }
}
