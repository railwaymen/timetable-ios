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
    func configure(viewModel: ServerConfigurationViewModelType)
}

class ServerConfigurationViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var serverAddressTextField: UITextField!
    @IBOutlet private var checkBoxButton: CheckBoxButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ServerConfigurationViewModelType?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction private func serverAddressTextFieldDidChange(_ sender: UITextField) {
        self.viewModel?.serverAddressDidChange(text: sender.text)
    }
    
    @IBAction private func continueButtonTapped(_ sender: UIButton) {
        self.viewModel?.continueButtonTapped()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel?.viewTapped()
    }
    
    @IBAction private func checkBoxButtonTapped(_ sender: CheckBoxButton) {
        self.viewModel?.checkboxButtonTapped(isActive: sender.isActive)
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
    func configure(viewModel: ServerConfigurationViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - ServerConfigurationViewModelOutput
extension ServerConfigurationViewController: ServerConfigurationViewModelOutput {
    func setUpView(checkBoxIsActive: Bool, serverAddress: String) {
        self.checkBoxButton.isActive = checkBoxIsActive
        self.serverAddressTextField.text = serverAddress
        self.continueButton.isEnabled = !serverAddress.isEmpty
        self.setUpActivityIndicator()
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        self.continueButton.isEnabled = isEnabled
        self.continueButton.backgroundColor = isEnabled ? .enabledButton : .disabledButton
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
        self.activityIndicator.set(isHidden: isHidden)
    }
    
    func setBottomContentInset(_ height: CGFloat) {
        guard self.isViewLoaded else { return }
        self.view.layoutIfNeeded()
        let bottomPadding: CGFloat = 16
        let verticalSpacing = self.continueButton.convert(self.continueButton.bounds, to: self.serverAddressTextField).minY
            -  self.serverAddressTextField.frame.height
        self.updateScrollViewInsets(with: max(height + verticalSpacing + bottomPadding, 0))
    }
}

// MARK: - Private
extension ServerConfigurationViewController {
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
