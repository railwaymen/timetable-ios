//
//  ProfileViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias ProfileViewControllerable = (UIViewController & ProfileViewModelOutput & ProfileViewControllerType)

protocol ProfileViewControllerType: class {
    func configure(viewModel: ProfileViewModelType)
}

class ProfileViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ProfileViewModelType!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction private func logoutButtonTapped(_ sender: UIButton) {
        self.viewModel.viewRequestedForLogout()
    }
}

// MARK: - ProfileViewModelOutput
extension ProfileViewController: ProfileViewModelOutput {
    func setUp() {
        self.firstNameLabel.text = ""
        self.lastNameLabel.text = ""
        self.emailLabel.text = ""
        self.setUpActivityIndicator()
        self.scrollView.isHidden = true
        self.errorView.isHidden = true
        self.viewModel.configure(self.errorView)
    }
    
    func update(firstName: String, lastName: String, email: String) {
        self.firstNameLabel.text = firstName
        self.lastNameLabel.text = lastName
        self.emailLabel.text = email
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = isHidden
    }
    
    func showScrollView() {
        UIView.transition(with: self.scrollView, duration: 0.2, animations: { [weak self] in
            self?.scrollView.isHidden = false
            self?.errorView.isHidden = true
        })
    }
    
    func showErrorView() {
        UIView.transition(with: self.errorView, duration: 0.2, animations: { [weak self] in
            self?.scrollView.isHidden = true
            self?.errorView.isHidden = false
        })
    }
}

// MARK: - ProfileViewControllerType
extension ProfileViewController: ProfileViewControllerType {
    func configure(viewModel: ProfileViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension ProfileViewController {
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            self.activityIndicator.style = .large
        } else {
            self.activityIndicator.style = .gray
        }
        self.setActivityIndicator(isHidden: true)
    }
}
