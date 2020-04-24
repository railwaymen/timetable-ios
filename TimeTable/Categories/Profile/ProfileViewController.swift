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

class ProfileViewController: UITableViewController {
    private var viewModel: ProfileViewModelType!
    
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.viewModel.cellType(for: indexPath)
        guard cellType == .button else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(ProfileButtonCell.self, for: indexPath) else { return UITableViewCell() }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.userSelectedCell(at: indexPath)
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        self.viewModel.closeButtonTapped()
    }
}

// MARK: - ProfileViewModelOutput
extension ProfileViewController: ProfileViewModelOutput {
    func setUp() {
        self.title = R.string.localizable.profile_title()
        self.tableView.register(ProfileButtonCell.self)
        self.setUpTableHeaderView()
        self.setUpBarButtons()
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
    private func setUpTableHeaderView() {
        guard let headerView = R.nib.profileHeaderView(owner: nil) else {
            return
        }
        self.viewModel.configure(headerView)
        self.tableView.tableHeaderView = headerView
    }
    
    private func setUpBarButtons() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.closeButtonTapped))
        self.navigationItem.setRightBarButtonItems([closeButton], animated: false)
    }
}
