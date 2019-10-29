//
//  ServerConfigurationViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias ServerConfigurationViewControllerable = (UIViewController & ServerConfigurationViewControllerType & ServerConfigurationViewModelOutput)

protocol ServerConfigurationViewControllerType: class {
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType)
}

class ServerConfigurationViewController: UIViewController {
 
    @IBOutlet private var scrollViewBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var serverAddressTextField: UITextField!
    @IBOutlet private var checkBoxButton: CheckBoxButton!
    
    private var viewModel: ServerConfigurationViewModelType?
    private var notificationCenter: NotificationCenterType?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.viewWillDisappear()
    }
    
    // MARK: - Actions
    @IBAction private func serverAddressTextFieldDidChange(_ sender: UITextField) {
        viewModel?.serverAddressDidChange(text: sender.text)
    }
    
    @IBAction private func continueButtonTapped(_ sender: UIButton) {
        viewModel?.viewRequestedToContinue()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        viewModel?.viewHasBeenTapped()
    }
    
    @IBAction private func checkBoxButtonTapped(_ sender: CheckBoxButton) {
        viewModel?.shouldRemeberHostCheckBoxStatusDidChange(isActive: sender.isActive)
    }
    
    // MARK: - Internal
    
    @objc func keyboardWillShow(notification: NSNotification, offset: CGFloat = 0) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
            updateConstraints(with: keyboardHeight - offset)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        updateConstraints()
    }
    
    // MARK: - Private
    private func updateConstraints(with height: CGFloat = 0) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollViewBottomLayoutConstraint.constant = height
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UITextFieldDelegate
extension ServerConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if serverAddressTextField == textField {
            return viewModel?.serverAddressTextFieldDidRequestForReturn() ?? false
        }
        return false
    }
}

// MARK: - ServerConfigurationViewControllerType
extension ServerConfigurationViewController: ServerConfigurationViewControllerType {
    func configure(viewModel: ServerConfigurationViewModelType, notificationCenter: NotificationCenterType) {
        self.notificationCenter = notificationCenter
        self.viewModel = viewModel
    }
}

// MARK: - ServerConfigurationViewModelOutput
extension ServerConfigurationViewController: ServerConfigurationViewModelOutput {
    func setupView(checkBoxIsActive: Bool, serverAddress: String) {
        notificationCenter?.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter?.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        checkBoxButton.isActive = checkBoxIsActive
        serverAddressTextField.text = serverAddress
        continueButton.isEnabled = !serverAddress.isEmpty
    }
    
    func tearDown() {
        notificationCenter?.removeObserver(self)
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        checkBoxButton.isActive = isActive
    }

    func dissmissKeyboard() {
        view.endEditing(true)
    }
}
