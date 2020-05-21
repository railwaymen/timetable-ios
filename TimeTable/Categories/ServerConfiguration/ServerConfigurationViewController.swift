//
//  ServerConfigurationViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias ServerConfigurationViewControllerable = (
    UIViewController
    & ServerConfigurationViewControllerType
    & ServerConfigurationViewModelOutput)

protocol ServerConfigurationViewControllerType: class {
    func configure(viewModel: ServerConfigurationViewModelType)
}

class ServerConfigurationViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var continueButton: LoadingButton!
    @IBOutlet private var serverAddressTextField: UITextField!
    
    @IBOutlet private var serverAddressTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var continueButtonHeightConstraint: NSLayoutConstraint!
    
    private var viewModel: ServerConfigurationViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.viewDidDisappear()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        self.viewModel.viewColorsShouldUpdate()
    }
    
    // MARK: - Actions
    @IBAction private func serverAddressTextFieldDidChange(_ sender: UITextField) {
        self.viewModel.serverAddressDidChange(text: sender.text)
    }
    
    @IBAction private func continueButtonTapped(_ sender: UIButton) {
        self.viewModel.continueButtonTapped()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel.viewTapped()
    }
}

// MARK: - UITextFieldDelegate
extension ServerConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard self.serverAddressTextField == textField else { return false }
        return self.viewModel.serverAddressTextFieldDidRequestForReturn()
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
    func setUpView(serverAddress: String) {
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle, compatibleWith: self.traitCollection).bold()
        self.serverAddressTextField.text = serverAddress
        self.serverAddressTextField.setTextFieldAppearance()
        self.setUpContinueButtonColors()
        self.setUpConstraints()
    }
    
    func continueButtonEnabledState(_ isEnabled: Bool) {
        self.continueButton.isEnabled = isEnabled
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.continueButton.set(isLoading: isAnimating)
    }
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        guard self.isViewLoaded else { return }
        self.view.layoutIfNeeded()
        let bottomPadding: CGFloat = 16
        let verticalSpacing = self.continueButton.convert(self.continueButton.bounds, to: self.serverAddressTextField).minY
            -  self.serverAddressTextField.frame.height
        let continueButtonHeight = self.continueButton.frame.height
        let preferredBottomInset = keyboardState.keyboardHeight + verticalSpacing + bottomPadding + continueButtonHeight
        self.updateScrollViewInsets(with: max(preferredBottomInset, 0))
    }
    
    func updateColors() {
        self.serverAddressTextField.setTextFieldAppearance()
        self.setUpContinueButtonColors()
    }
}

// MARK: - Private
extension ServerConfigurationViewController {
    private func setUpContinueButtonColors() {
        self.continueButton.setBackgroundColor(.enabledButton, forState: .normal)
        self.continueButton.setBackgroundColor(.disabledButton, forState: .disabled)
    }
    
    private func updateScrollViewInsets(with height: CGFloat = 0) {
        self.scrollView.contentInset.bottom = height
        self.scrollView.verticalScrollIndicatorInsets.bottom = height
    }
    
    private func setUpConstraints() {
        self.serverAddressTextFieldHeightConstraint.constant = Constants.defaultTextFieldHeight
        self.continueButtonHeightConstraint.constant = Constants.defaultButtonHeight
    }
}
