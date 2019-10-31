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
        notificationCenter?.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
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
    
    // MARK: - Notifications
    @objc private func changeKeyboardFrame(notification: NSNotification, offset: CGFloat = 0) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        let bottomSpaceInScrollView = scrollView.contentSize.height - continueButton.convert(continueButton.bounds, to: scrollView).maxY
        updateScrollViewInsets(with: max(keyboardHeight - bottomSpaceInScrollView, 0))
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        updateScrollViewInsets()
    }
    
    // MARK: - Private
    private func updateScrollViewInsets(with height: CGFloat = 0) {
        self.scrollView.contentInset.bottom = height
        self.scrollView.scrollIndicatorInsets.bottom = height
    }
}

// MARK: - UITextFieldDelegate
extension ServerConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard serverAddressTextField == textField else { return false }
        return viewModel?.serverAddressTextFieldDidRequestForReturn() ?? false
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
        notificationCenter?.addObserver(self, selector: #selector(changeKeyboardFrame), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter?.addObserver(self, selector: #selector(changeKeyboardFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        checkBoxButton.isActive = checkBoxIsActive
        serverAddressTextField.text = serverAddress
        continueButton.isEnabled = !serverAddress.isEmpty
        setActivityIndicator(isHidden: true)
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        UIView.transition(
            with: checkBoxButton,
            duration: 0.15,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.checkBoxButton.isActive = isActive
        })
    }

    func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        activityIndicator.isHidden = isHidden
    }
}
