//
//  ServerSettingsViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 26/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ServerSettingsViewControllerType: class {
    func configure(viewModel: ServerSettingsViewModelType, notificationCenter: NotificationCenterType)
}

class ServerSettingsViewController: UIViewController {
 
    @IBOutlet private var scrollViewBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private var continueButton: UIButton!
    
    private var viewModel: ServerSettingsViewModelType?
    private var notificationCenter: NotificationCenterType?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.viewWillDisappear()
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
            self.scrollViewBottomLayoutConstraint.constant = height
            self.view.layoutIfNeeded()
        })
    }
}

extension ServerSettingsViewController: ServerSettingsViewControllerType {
    func configure(viewModel: ServerSettingsViewModelType, notificationCenter: NotificationCenterType) {
        self.notificationCenter = notificationCenter
        self.viewModel = viewModel
    }
}

extension ServerSettingsViewController: ServerSettingsViewModelOutput {
    func setupView() {
        notificationCenter?.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter?.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func tearDown() {
        notificationCenter?.removeObserver(self)
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }
}
