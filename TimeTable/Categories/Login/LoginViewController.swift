//
//  LoginViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 30/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

typealias LoginViewControllerable = (UIViewController & LoginViewControllerType & LoginViewModelOutput)

protocol LoginViewControllerType: class {
    func configure(viewModel: LoginViewModelType)
}

class LoginViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var checkBoxButton: CheckBoxButton!
    @IBOutlet private var loginButton: LoadingButton!
    
    @IBOutlet private var textFieldHeightConstraints: [NSLayoutConstraint]!
    @IBOutlet private var loginButtonHeightConstraint: NSLayoutConstraint!
    
    private var viewModel: LoginViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.viewDidDisappear()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        self.viewModel.viewShouldUpdateColors()
    }

    // MARK: - Actions
    @IBAction private func loginTextFieldDidChange(_ sender: UITextField) {
        self.viewModel.loginInputValueDidChange(value: sender.text)
    }
    
    @IBAction private func passwordTextFieldDidChange(_ sender: UITextField) {
        self.viewModel.passwordInputValueDidChange(value: sender.text)
    }
    
    @IBAction private func loginButtonTapped(sender: UIButton) {
        self.viewModel.viewRequestedToLogin()
    }
    
    @IBAction private func checkBoxButtonTapped(_ sender: CheckBoxButton) {
        self.viewModel?.shouldRememberUserBoxStatusDidChange(isActive: sender.isActive)
    }
    
    @IBAction private func viewTapped(_ sender: Any) {
        self.viewModel?.viewTapped()
    }
}

// MARK: - LoginViewModelOutput
extension LoginViewController: LoginViewModelOutput {
    func setUpView(checkBoxIsActive: Bool) {
        self.checkBoxButton.isActive = checkBoxIsActive
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle, compatibleWith: self.traitCollection).bold()
        self.setUpLoginTextField()
        self.setUpPasswordTextField()
        self.setUpLoginButtonColors()
        self.setUpConstraints()
    }
    
    func updateColors() {
        self.loginTextField.setTextFieldAppearance()
        self.passwordTextField.setTextFieldAppearance()
        self.setUpLoginButtonColors()
    }
    
    func updateLoginFields(email: String, password: String) {
        self.loginTextField.text = email
        self.passwordTextField.text = password
    }
    
    func loginButtonEnabledState(_ isEnabled: Bool) {
        self.loginButton.isEnabled = isEnabled
    }
    
    func focusOnPasswordTextField() {
        self.passwordTextField.becomeFirstResponder()
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
        self.loginButton.set(isLoading: !isHidden)
    }
    
    func keyboardStateDidChange(to keyboardState: KeyboardManager.KeyboardState) {
        guard self.isViewLoaded else { return }
        self.view.layoutIfNeeded()
        let bottomPadding: CGFloat = 16
        let verticalSpacing = self.loginButton.convert(self.loginButton.bounds, to: self.passwordTextField).minY
        self.updateScrollViewInsets(with: max(keyboardState.keyboardHeight + verticalSpacing + bottomPadding, 0))
    }
    
    func setLoginTextField(isHighlighted: Bool) {
        self.set(self.loginTextField, isHighlighted: isHighlighted)
    }
    
    func setPasswordTextField(isHighlighted: Bool) {
        self.set(self.passwordTextField, isHighlighted: isHighlighted)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.loginTextField:
            return self.viewModel.loginTextFieldDidRequestForReturn()
        case self.passwordTextField:
            return self.viewModel.passwordTextFieldDidRequestForReturn()
        default:
            return true
        }
    }
}

// MARK: - LoginViewControllerType
extension LoginViewController: LoginViewControllerType {
    func configure(viewModel: LoginViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension LoginViewController {
    private func updateScrollViewInsets(with height: CGFloat = 0) {
        self.scrollView.contentInset.bottom = height
        self.scrollView.verticalScrollIndicatorInsets.bottom = height
    }
    
    private func setUpLoginTextField() {
        self.loginTextField.delegate = self
        self.loginTextField.setTextFieldAppearance()
    }
    
    private func setUpPasswordTextField() {
        self.passwordTextField.delegate = self
        self.passwordTextField.setTextFieldAppearance()
    }
    
    private func setUpLoginButtonColors() {
        self.loginButton.setBackgroundColor(.enabledButton, forState: .normal)
        self.loginButton.setBackgroundColor(.disabledButton, forState: .disabled)
    }
    
    private func setUpConstraints() {
        self.textFieldHeightConstraints.forEach {
            $0.constant = Constants.defaultTextFieldHeight
        }
        self.loginButtonHeightConstraint.constant = Constants.defaultButtonHeight
    }
    
    private func set(_ view: UIView, isHighlighted: Bool) {
        view.set(
            borderColor: .textFieldBorderColor(isHighlighted: isHighlighted),
            animatingWithDuration: 0.3)
    }
}
