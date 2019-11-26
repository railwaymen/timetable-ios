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

    private let contentInset = UIEdgeInsets(top: 30, left: 18, bottom: 30, right: 18)
    private let projectCellTableViewHeight: CGFloat = 28
    private let projectCellStaticHeaderHeight: CGFloat = 88

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
}

// MARK: - UICollectionViewDataSource
extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusedCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let cell = reusedCell as? ProjectCollectionViewCell else { return UICollectionViewCell() }
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
        self.collectionView.contentInset = self.contentInset
        if let layout = self.collectionView.collectionViewLayout as? ProjectsCollectionViewLayout {
            layout.delegate = self
        }
        self.title = "tabbar.title.projects".localized
        self.collectionView.isHidden = true
        self.errorView.isHidden = true
        self.setUpActivityIndicator()
        self.viewModel.configure(self.errorView)
    }
    
    func updateView() {
        self.collectionView.reloadData()
    }
    
    func showCollectionView() {
        UIView.transition(with: collectionView, duration: 0.2, animations: { [weak self] in
            self?.collectionView.isHidden = false
            self?.errorView.isHidden = true
        })
    }
    
    func showErrorView() {
        UIView.transition(with: errorView, duration: 0.2, animations: { [weak self] in
            self?.collectionView.isHidden = true
            self?.errorView.isHidden = false
        })
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = isHidden
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
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            self.activityIndicator.style = .large
        } else {
            self.activityIndicator.style = .gray
        }
        self.setActivityIndicator(isHidden: true)
    }
}
