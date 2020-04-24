//
//  VacationViewContorller.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias VacationViewControllerable = (UIViewController & VacationViewControllerType & VacationViewModelOutput)

protocol VacationViewControllerType: class {
    func configure(viewModel: VacationViewModelType)
}

class VacationViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: VacationViewModelType!

    // MARK: - Overridden
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    // MARK: - Actions
    @objc private func profileButtonTapped() {
        self.viewModel.viewRequestForProfileView()
    }
}

// MARK: - UITableViewDataSource
extension VacationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(VacationCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension VacationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - VacationViewModelOutput
extension VacationViewController: VacationViewModelOutput {
    func setUpView() {
        self.setUpNavigationItem()
        self.setUpBarButtons()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(VacationCell.self)
    }
    
    func showTableView() {
        UIView.transition(with: self.tableView, duration: 0.2, animations: { [weak self] in
            self?.tableView.set(isHidden: false)
            self?.errorView.set(isHidden: true)
        })
    }
    
    func showErrorView() {
        UIView.transition(with: errorView, duration: 0.2, animations: { [weak self] in
            self?.tableView.set(isHidden: true)
            self?.errorView.set(isHidden: false)
        })
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
}

// MARK: - VacationViewControllerType
extension VacationViewController: VacationViewControllerType {
    func configure(viewModel: VacationViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension VacationViewController {
    private func setUpNavigationItem() {
        self.title = R.string.localizable.vacation_title()
    }
    
    private func setUpBarButtons() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let profileImageView = self.buildImageView(image: .profile, action: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([profileImageView])
    }
    
    private func buildImageView(image: UIImage?, action: Selector) -> UIImageView {
        let imageView = UIImageView(image: image)
        let tap = UITapGestureRecognizer(target: self, action: action)
        imageView.tintColor = .tint
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }
}
