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
    @IBOutlet private var loginButton: UIButton!
    
    private var notificationCenter: NotificationCenterType!
    private var viewModel: LoginViewModelType!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.viewWillDisappear()
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
    func setUpView() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        loginButton.isEnabled = false
        passwordTextField.isEnabled = false
        passwordTextField.isSecureTextEntry = true
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
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
