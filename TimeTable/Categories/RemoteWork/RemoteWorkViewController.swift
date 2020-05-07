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
    private var viewModel: RemoteWorkViewModelType!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let tableViewEstimatedRowHeight: CGFloat = 80
    
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
    @objc private func addNewRecordTapped() {
        self.viewModel.addNewRecordTapped()
    }
    
    @objc private func profileButtonTapped() {
        self.viewModel.profileButtonTapped()
    }
}

// MARK: - UITableViewDelegate
extension RemoteWorkViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: []) // TO_DO TIM-287
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

// MARK: - RemoteWorkViewModelOutput
extension RemoteWorkViewController: RemoteWorkViewModelOutput {
    func setUp() {
        self.tableView.set(isHidden: true)
        self.setUpTitle()
        self.setUpBarButtons()
        self.setUpActivityIndicator()
        self.setUpBarButtons()
        self.setUpTableView()
    }
    
    func showTableView() {
        UIView.transition(with: self.tableView, duration: 0.2, animations: { [weak self] in
            self?.tableView.set(isHidden: false)
        })
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
    
    func updateView() {
        self.tableView.reloadData()
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
        let addImageView = self.buildImageView(image: .plus, action: #selector(self.addNewRecordTapped))
        let profileImageView = self.buildImageView(image: .profile, action: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([addImageView, profileImageView])
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
    
    private func setUpActivityIndicator() {
        self.activityIndicator.style = .large
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableViewEstimatedRowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(RemoteWorkCell.self)
    }
}
