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

    // MARK: - Lifecycle
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
}

// MARK: - UICollectionViewDataSource
extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ProjectCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
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
    func collectionView(_ collectionView: UICollectionView, heightForUsersTableViewAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let project = self.viewModel.item(at: indexPath) else { return 0 }
        return CGFloat(project.users.count) * self.projectCellTableViewHeight + self.projectCellStaticHeaderHeight
    }
}

// MARK: - ProjectsViewModelOutput
extension ProjectsViewController: ProjectsViewModelOutput {
    func setUpView() {
        self.title = "tabbar.title.projects".localized
        self.setUpCollectionView()
        self.setUpActivityIndicator()
        self.setUpErrorView()
        self.setUpRefreshControl()
    }
    
    func updateView() {
        self.collectionView.reloadData()
    }
    
    func showCollectionView() {
        UIView.transition(with: collectionView, duration: 0.2, animations: { [weak self] in
            self?.collectionView.set(isHidden: false)
            self?.errorView.set(isHidden: true)
        })
    }
    
    func showErrorView() {
        UIView.transition(with: errorView, duration: 0.2, animations: { [weak self] in
            self?.collectionView.set(isHidden: true)
            self?.errorView.set(isHidden: false)
        })
    }
    
    func setActivityIndicator(isHidden: Bool) {
        self.activityIndicator.set(isAnimating: !isHidden)
    }
    
    func screenOrientationDidChange() {
        guard let collectionView = self.collectionView else { return }
        collectionView.setNeedsLayout()
        guard let layout = collectionView.collectionViewLayout as? ProjectsCollectionViewLayout else { return assertionFailure() }
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
        self.collectionView.set(isHidden: true)
    }
    
    private func setUpErrorView() {
        self.errorView.set(isHidden: true)
        self.viewModel.configure(self.errorView)
    }
    
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            self.activityIndicator.style = .large
        } else {
            self.activityIndicator.style = .gray
        }
        self.activityIndicator.hidesWhenStopped = true
        self.setActivityIndicator(isHidden: true)
    }
    
    private func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.viewDidRequestToRefresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
}
