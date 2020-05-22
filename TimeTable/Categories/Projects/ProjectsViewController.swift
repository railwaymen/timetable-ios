//
//  ProjectsViewController.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias ProjectsViewControllerable = (UIViewController & ProjectsViewControllerType & ProjectsViewModelOutput)

protocol ProjectsViewControllerType: class {
    func configure(viewModel: ProjectsViewModelType)
}

class ProjectsViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var errorView: ErrorView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ProjectsViewModelType!

    private let contentInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    private let projectCellTableViewHeight: CGFloat = 28
    private let projectCellStaticHeaderHeight: CGFloat = 88

    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func viewDidRequestToRefresh() {
        self.viewModel.refreshData { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func profileButtonTapped() {
        self.viewModel.profileButtonTapped()
    }
}

// MARK: - UICollectionViewDataSource
extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ProjectCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        guard let project = self.viewModel.item(at: indexPath) else { return UICollectionViewCell() }
        let cellViewModel = ProjectCollectionViewCellModel(userInterface: cell, project: project)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProjectsViewController: UICollectionViewDelegate {}

// MARK: - ProjectsCollectionViewLayoutDelegate
extension ProjectsViewController: ProjectsCollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForUsersTableViewAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        guard let project = self.viewModel.item(at: indexPath) else { return 0 }
        return CGFloat(project.users.count) * self.projectCellTableViewHeight + self.projectCellStaticHeaderHeight
    }
}

// MARK: - ContainerViewControllerType
extension ProjectsViewController: ContainerViewControllerType {
    var containedViews: [UIView] {
        [self.collectionView, self.errorView].compactMap { $0 }
    }
}

// MARK: - ProjectsViewModelOutput
extension ProjectsViewController: ProjectsViewModelOutput {
    func setUpView() {
        self.title = R.string.localizable.projects_title()
        self.setUpCollectionView()
        self.setUpErrorView()
        self.setUpRefreshControl()
        self.setUpBarButtons()
        self.hideAllContainedViews()
    }
    
    func updateView() {
        self.collectionView.reloadData()
    }
    
    func showCollectionView() {
        self.showWithAnimation(view: self.collectionView, duration: Constants.slowTransitionDuration)
    }
    
    func showErrorView() {
        self.showWithAnimation(view: self.errorView, duration: Constants.slowTransitionDuration)
    }
    
    func setActivityIndicator(isAnimating: Bool) {
        self.activityIndicator.set(isAnimating: isAnimating)
    }
    
    func screenOrientationDidChange() {
        guard let collectionView = self.collectionView else { return }
        collectionView.setNeedsLayout()
        guard let layout = collectionView.collectionViewLayout as? ProjectsCollectionViewLayout else {
            return assertionFailure()
        }
        layout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
}

// MARK: - ProjectsViewControllerType
extension ProjectsViewController: ProjectsViewControllerType {
    func configure(viewModel: ProjectsViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - Private
extension ProjectsViewController {
    private func setUpCollectionView() {
        self.collectionView.contentInset = self.contentInset
        self.collectionView.register(ProjectCollectionViewCell.self)
        if let layout = self.collectionView.collectionViewLayout as? ProjectsCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    private func setUpErrorView() {
        self.viewModel.configure(self.errorView)
    }
    
    private func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.viewDidRequestToRefresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    private func setUpBarButtons() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let profileImageView = self.buildImageView(image: .profile, tapAction: #selector(self.profileButtonTapped))
        navigationBar.setLargeTitleRightViews([profileImageView])
    }
}
