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
 
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var serverAddressTextField: UITextField!
    @IBOutlet private var checkBoxButton: CheckBoxButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ServerConfigurationViewModelType?
    private var notificationCenter: NotificationCenterType?
    
    // MARK: - Initialization
    deinit {
        self.notificationCenter?.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction private func serverAddressTextFieldDidChange(_ sender: UITextField) {
        self.viewModel?.serverAddressDidChange(text: sender.text)
    }
    
    @IBAction private func continueButtonTapped(_ sender: UIButton) {
        self.viewModel?.viewRequestedToContinue()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel?.viewHasBeenTapped()
    }
    
    @IBAction private func checkBoxButtonTapped(_ sender: CheckBoxButton) {
        self.viewModel?.shouldRemeberHostCheckBoxStatusDidChange(isActive: sender.isActive)
    }
    
    // MARK: - Notifications
    @objc private func changeKeyboardFrame(notification: NSNotification, offset: CGFloat = 0) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        let bottomSpaceInScrollView = self.scrollView.contentSize.height - self.continueButton.convert(self.continueButton.bounds, to: self.scrollView).maxY
        self.updateScrollViewInsets(with: max(keyboardHeight - bottomSpaceInScrollView, 0))
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.updateScrollViewInsets()
    }
    
    // MARK: - Private
    private func updateScrollViewInsets(with height: CGFloat = 0) {
        self.scrollView.contentInset.bottom = height
        self.scrollView.scrollIndicatorInsets.bottom = height
    }
    
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            self.activityIndicator.style = .large
        } else {
            self.activityIndicator.style = .gray
        }
        self.setActivityIndicator(isHidden: true)
    }
}

// MARK: - UITextFieldDelegate
extension ServerConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard self.serverAddressTextField == textField else { return false }
        return self.viewModel?.serverAddressTextFieldDidRequestForReturn() ?? false
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
    func setUpView(checkBoxIsActive: Bool, serverAddress: String) {
        self.notificationCenter?.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.notificationCenter?.addObserver(self, selector: #selector(self.changeKeyboardFrame), name: UIResponder.keyboardDidShowNotification, object: nil)
        self.notificationCenter?.addObserver(self, selector: #selector(self.changeKeyboardFrame),
                                             name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.checkBoxButton.isActive = checkBoxIsActive
        self.serverAddressTextField.text = serverAddress
        self.continueButton.isEnabled = !serverAddress.isEmpty
        self.setUpActivityIndicator()
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        self.continueButton.isEnabled = isEnabled
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        UIView.transition(
            with: self.checkBoxButton,
            duration: 0.15,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.checkBoxButton.isActive = isActive
        })
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = isHidden
    }
}
