//
//  UserProfileViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias UserProfileViewControllerable = (UIViewController & UserProfileViewModelOutput & UserProfileViewControllerType)

protocol UserProfileViewControllerType: class {
    func configure(viewModel: UserProfileViewModelType)
}

class UserProfileViewController: UIViewController {
    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    
    private var viewModel: UserProfileViewModelType!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Action
    @IBAction private func logoutButtonTapped(_ sender: UIButton) {
        viewModel.viewRequestedForLogout()
    }
}

// MARK: - UserProfileViewModelOutput
extension UserProfileViewController: UserProfileViewModelOutput {
    func setUp() {
        firstNameLabel.text = ""
        lastNameLabel.text = ""
        emailLabel.text = ""
    }
    
    func update(firstName: String, lastName: String, email: String) {
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        emailLabel.text = email
    }
}

// MARK: - UserProfileViewControllerType
extension UserProfileViewController: UserProfileViewControllerType {
    func configure(viewModel: UserProfileViewModelType) {
        self.viewModel = viewModel
    }
}
