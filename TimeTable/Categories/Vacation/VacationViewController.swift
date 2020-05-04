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
    
    private let tableViewEstimatedRowHeight: CGFloat = 70
    private var viewModel: VacationViewModelType!

    // MARK: - Overridden
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    // MARK: - Actions
    @objc private func addVacationButtonTapped() {
        self.viewModel.viewRequestForVacationForm()
    }
    
    @objc private func profileButtonTapped() {
        self.viewModel.viewRequestForProfileView()
    }
    
    @IBAction private func viewTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel?.viewHasBeenTapped()
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
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = self.buildDeleteContextualAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - VacationViewModelOutput
extension VacationViewController: VacationViewModelOutput {
    func setUpView() {
        self.tableView.set(isHidden: true)
        self.errorView.set(isHidden: true)
        self.setUpNavigationItem()
        self.setUpBarButtons()
        self.setUpTableHeaderView()
        self.setUpTableView()
        self.viewModel.configure(self.errorView)
    }
    
    func setUpTableHeaderView() {
        guard let headerView = R.nib.vacationTableHeader(owner: nil) else { return }
        self.viewModel.configure(headerView)
        self.tableView.tableHeaderView = headerView
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
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
        let addImageView = self.buildImageView(image: .plus, action: #selector(self.addVacationButtonTapped))
        let profileImageView = self.buildImageView(image: .profile, action: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([addImageView, profileImageView])
    }
    
    private func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = self.tableViewEstimatedRowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(VacationCell.self)
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
    
    private func buildDeleteContextualAction(indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return completion(false) }
            self.viewModel.viewRequestToDeclineVacation(at: indexPath) { completed in
                completion(completed)
            }
        }
        deleteAction.backgroundColor = .deleteAction
        deleteAction.image = .delete
        return deleteAction
    }
}
