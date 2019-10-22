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
    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    
    private var viewModel: ProfileViewModelType!
    
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

// MARK: - ProfileViewModelOutput
extension ProfileViewController: ProfileViewModelOutput {
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

// MARK: - ProfileViewControllerType
extension ProfileViewController: ProfileViewControllerType {
    func configure(viewModel: ProfileViewModelType) {
        self.viewModel = viewModel
    }
}
