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

class ProjectsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ProjectsViewModelType!

    private let cellIdentifier = "ProjectCollectionViewCellReuseIdentifier"
    private let contentInset = UIEdgeInsets(top: 30, left: 18, bottom: 30, right: 18)
    private let projectCellTableViewHeight: CGFloat = 28
    private let projectCellStaticHeaderHeight: CGFloat = 88

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
      
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProjectCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let project = viewModel.item(at: indexPath) else { return UICollectionViewCell() }
        let cellViewModel = ProjectCollectionViewCellModel(userInterface: cell, project: project)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    // MARK: - Private
    private func setUpActivityIndicator() {
        if #available(iOS 13, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        setActivityIndicator(isHidden: true)
    }
}

// MARK: - ProjectsViewModelOutput
extension ProjectsViewController: ProjectsViewModelOutput {
    
    func setUpView() {
        collectionView.contentInset = self.contentInset
        if let layout = collectionView.collectionViewLayout as? ProjectsCollectionViewLayout {
            layout.delegate = self
        }
        self.title = "tabbar.title.projects".localized
        setUpActivityIndicator()
    }
    
    func updateView() {
        collectionView.reloadData()
    }
    
    func setActivityIndicator(isHidden: Bool) {
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        activityIndicator.isHidden = isHidden
    }
}

// MARK: - ProjectsViewControllerType
extension ProjectsViewController: ProjectsViewControllerType {
    func configure(viewModel: ProjectsViewModelType) {
        self.viewModel = viewModel
    }
}

// MARK: - ProjectsCollectionViewLayoutDelegate
extension ProjectsViewController: ProjectsCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForUsersTableViewAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let project = viewModel.item(at: indexPath) else { return 0 }
        return CGFloat(project.users.count) * projectCellTableViewHeight + projectCellStaticHeaderHeight
    }
}
