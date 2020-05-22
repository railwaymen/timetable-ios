//
//  RemoteWorkViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias RemoteWorkViewControllerable = (UIViewController & RemoteWorkViewModelOutput & RemoteWorkViewControllerType)

protocol RemoteWorkViewControllerType: class {
    func configure(viewModel: RemoteWorkViewModelType)
}

class RemoteWorkViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: RemoteWorkViewModelType!
    
    private let minimumCellHeight: CGFloat = 74
    
    // MARK: - Overridden
    override func loadView() {
        super.loadView()
        self.viewModel.loadView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewModel.viewDidLayoutSubviews()
    }
    
    // MARK: - Actions
    @objc private func addNewRecordTapped() {
        self.viewModel.addNewRecordTapped()
    }
    
    @objc private func profileButtonTapped() {
        self.viewModel.profileButtonTapped()
    }
    
    @objc private func viewRequestToRefresh() {
        self.viewModel.viewRequestToRefresh { [weak self] in
            guard let refreshControl = self?.tableView.refreshControl else { return }
            guard refreshControl.isRefreshing else { return }
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate
extension RemoteWorkViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = self.deleteAction(for: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.viewWillDisplayCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.viewDidSelectCell(at: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension RemoteWorkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(RemoteWorkCell.self, for: indexPath) else { return UITableViewCell() }
        self.viewModel.configure(cell, for: indexPath)
        return cell
    }
}

// MARK: - ContainerViewControllerType
extension RemoteWorkViewController: ContainerViewControllerType {
    var containedViews: [UIView] {
        [self.tableView, self.errorView].compactMap { $0 }
    }
}

// MARK: - RemoteWorkViewModelOutput
extension RemoteWorkViewController: RemoteWorkViewModelOutput {
    func setUp() {
        self.setUpTitle()
        self.setUpBarButtons()
        self.setUpTableView()
        self.setUpRefreshControl()
        self.hideAllContainedViews()
        self.viewModel.configure(self.errorView)
    }
    
    func showTableView() {
        self.showWithAnimation(view: self.tableView, duration: Constants.slowTransitionDuration)
    }
    
    func showErrorView() {
        self.showWithAnimation(view: self.errorView, duration: Constants.slowTransitionDuration)
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.activityIndicator.set(isAnimating: isAnimating)
    }
    
    func setBottomContentInset(isHidden: Bool) {
        self.tableView.contentInset.bottom = isHidden ? 0 : self.minimumCellHeight
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    func removeRows(at indexPaths: [IndexPath]) {
        self.tableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    func getMaxCellsPerTableHeight() -> Int {
        self.tableView.getMaxCellsCountPerTableHeight(minimumCellHeight: self.minimumCellHeight)
    }
    
    func deselectAllRows() {
        self.tableView.deselectAllRows(animated: true)
    }
}

// MARK: - RemoteWorkViewControllerType
extension RemoteWorkViewController: RemoteWorkViewControllerType {
    func configure(viewModel: RemoteWorkViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension RemoteWorkViewController {
    private func setUpTitle() {
        self.title = R.string.localizable.remotework_title()
    }
    
    private func setUpBarButtons() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let addImageView = self.buildImageView(image: .plus, tapAction: #selector(self.addNewRecordTapped))
        let profileImageView = self.buildImageView(image: .profile, tapAction: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([addImageView, profileImageView])
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(RemoteWorkCell.self)
        self.setBottomContentInset(isHidden: false)
    }
    
    private func deleteAction(for indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "") {
            [weak self] (_, _, completion) in
            guard let self = self else { return completion(false) }
            self.viewModel.viewRequestToDelete(at: indexPath, completion: completion)
        }
        deleteAction.backgroundColor = .deleteAction
        deleteAction.image = .delete
        return deleteAction
    }
    
    private func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.viewRequestToRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
}
