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
    
    @IBOutlet private var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var checkBoxButton: CheckBoxButton!
    @IBOutlet private var loginButton: UIButton!
    
    private var notificationCenter: NotificationCenterType!
    private var viewModel: LoginViewModelType!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Action
    @IBAction private func loginTextFieldDidChange(_ sender: UITextField) {
        viewModel.loginInputValueDidChange(value: sender.text)
    }
    
    @IBAction private func passwordTextFieldDidChange(_ sender: UITextField) {
        viewModel.passwordInputValueDidChange(value: sender.text)
    }
    
    @IBAction private func loginButtonTapped(sender: UIButton) {
        viewModel.viewRequestedToLogin()
    }
    
    @IBAction private func checkBoxButtonTapped(_ sender: CheckBoxButton) {
        viewModel?.shouldRemeberUserBoxStatusDidChange(isActive: sender.isActive)
    }
    
    @IBAction private func changeServerAddressTapped(sender: UIButton) {
        viewModel.viewRequestedToChangeServerAddress()
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
            self.bottomLayoutConstraint.constant = height
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - LoginViewModelOutput
extension LoginViewController: LoginViewModelOutput {
    func setUpView(checkBoxIsActive: Bool) {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        checkBoxButton.isActive = checkBoxIsActive
        passwordTextField.isSecureTextEntry = true
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func updateLoginFields(email: String, password: String) {
        loginTextField.text = email
        passwordTextField.text = password
        passwordTextField.isEnabled = !password.isEmpty
        loginButton.isEnabled = !(email.isEmpty && password.isEmpty)
    }
    
    func tearDown() {
        notificationCenter.removeObserver(self)
    }
    
    func passwordInputEnabledState(_ isEnabled: Bool) {
        passwordTextField.isEnabled = isEnabled
    }
    
    func loginButtonEnabledState(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
    }
    
    func focusOnPasswordTextField() {
        passwordTextField.becomeFirstResponder()
    }
    
    func checkBoxIsActiveState(_ isActive: Bool) {
        checkBoxButton.isActive = isActive
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            return viewModel.loginTextFieldDidRequestForReturn()
        case passwordTextField:
            return viewModel.passwordTextFieldDidRequestForReturn()
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
