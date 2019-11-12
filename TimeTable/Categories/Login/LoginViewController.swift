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
    func configure(notificationCenter: NotificationCenterType, viewModel: LoginViewModelType)
}

class LoginViewController: UIViewController {
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var checkBoxButton: CheckBoxButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var notificationCenter: NotificationCenterType!
    private var viewModel: LoginViewModelType!
    
    // MARK: - Initialization
    deinit {
        self.notificationCenter?.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Action
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
        self.viewModel?.shouldRemeberUserBoxStatusDidChange(isActive: sender.isActive)
    }
    
    @IBAction private func viewTapped(_ sender: Any) {
        self.viewModel?.viewTapped()
    }
    
    // MARK: - Notifications
    @objc private func changeKeyboardFrame(notification: NSNotification, offset: CGFloat = 0) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        let bottomSpaceInScrollView = self.scrollView.contentSize.height - self.loginButton.convert(self.loginButton.bounds, to: self.scrollView).maxY
        self.updateScrollViewInsets(with: max(keyboardHeight - offset - bottomSpaceInScrollView, 0))
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

// MARK: - LoginViewModelOutput
extension LoginViewController: LoginViewModelOutput {
    func setUpView(checkBoxIsActive: Bool) {
        self.notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(self.changeKeyboardFrame), name: UIResponder.keyboardDidShowNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(self.changeKeyboardFrame),
                                            name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.checkBoxButton.isActive = checkBoxIsActive
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
        self.setUpActivityIndicator()
    }
    
    func updateLoginFields(email: String, password: String) {
        self.loginTextField.text = email
        self.passwordTextField.text = password
        self.passwordTextField.isEnabled = !password.isEmpty
        self.loginButton.isEnabled = !(email.isEmpty && password.isEmpty)
    }
    
    func passwordInputEnabledState(_ isEnabled: Bool) {
        self.passwordTextField.isEnabled = isEnabled
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
        isHidden ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = isHidden
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
    func configure(notificationCenter: NotificationCenterType, viewModel: LoginViewModelType) {
        self.notificationCenter = notificationCenter
        self.viewModel = viewModel
    }
}
