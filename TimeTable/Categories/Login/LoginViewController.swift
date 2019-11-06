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
        notificationCenter?.removeObserver(self)
    }
    
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
    
    @IBAction private func viewTapped(_ sender: Any) {
        viewModel?.viewTapped()
    }
    
    // MARK: - Notifications
    @objc private func changeKeyboardFrame(notification: NSNotification, offset: CGFloat = 0) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else { return }
        let bottomSpaceInScrollView = scrollView.contentSize.height - loginButton.convert(loginButton.bounds, to: scrollView).maxY
        updateScrollViewInsets(with: max(keyboardHeight - offset - bottomSpaceInScrollView, 0))
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        updateScrollViewInsets()
    }
    
    // MARK: - Private
    private func updateScrollViewInsets(with height: CGFloat = 0) {
        self.scrollView.contentInset.bottom = height
        self.scrollView.scrollIndicatorInsets.bottom = height
    }
    
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        setActivityIndicator(isHidden: true)
    }
}

// MARK: - LoginViewModelOutput
extension LoginViewController: LoginViewModelOutput {
    func setUpView(checkBoxIsActive: Bool) {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(changeKeyboardFrame), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(changeKeyboardFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        checkBoxButton.isActive = checkBoxIsActive        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        setUpActivityIndicator()
    }
    
    func updateLoginFields(email: String, password: String) {
        loginTextField.text = email
        passwordTextField.text = password
        passwordTextField.isEnabled = !password.isEmpty
        loginButton.isEnabled = !(email.isEmpty && password.isEmpty)
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
        UIView.transition(
            with: checkBoxButton,
            duration: 0.15,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.checkBoxButton.isActive = isActive
            })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        activityIndicator.isHidden = isHidden
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
