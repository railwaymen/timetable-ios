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
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var checkBoxButton: CheckBoxButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
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
        self.loginTextField.delegate = self
        self.loginTextField.setTextFieldAppearance()
        self.passwordTextField.delegate = self
        self.passwordTextField.setTextFieldAppearance()
        self.setUpActivityIndicator()
        self.setUpConstraints()
    }
    
    func updateLoginFields(email: String, password: String) {
        self.loginTextField.text = email
        self.passwordTextField.text = password
    }
    
    func loginButtonEnabledState(_ isEnabled: Bool) {
        self.loginButton.isEnabled = isEnabled
        self.loginButton.backgroundColor = isEnabled ? .enabledButton : .disabledButton
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
        self.activityIndicator.set(isAnimating: !isHidden)
        self.activityIndicator.set(isHidden: isHidden)
    }
    
    func setBottomContentInset(_ height: CGFloat) {
        guard self.isViewLoaded else { return }
        self.view.layoutIfNeeded()
        let bottomPadding: CGFloat = 16
        let verticalSpacing = self.loginButton.convert(self.loginButton.bounds, to: self.passwordTextField).minY
        self.updateScrollViewInsets(with: max(height + verticalSpacing + bottomPadding, 0))
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
    
    private func setUpActivityIndicator() {
        self.activityIndicator.style = .large
        self.setActivityIndicator(isHidden: true)
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
