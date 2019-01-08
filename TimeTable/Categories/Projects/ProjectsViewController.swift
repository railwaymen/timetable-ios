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

class ProjectsViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet private var collectionView: UICollectionView!
    private var viewModel: ProjectsViewModelType!

    private let cellIdentifier = "ProjectCollectionViewCellReuseIdentifier"
    private let contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    private let projectCellTableViewHeight: CGFloat = 44
    private let projectCellStaticHeaderHeight: CGFloat = 50

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
}

// MARK: - ProjectsViewModelOutput
extension ProjectsViewController: ProjectsViewModelOutput {
    
    func setUpView() {
        collectionView.contentInset = self.contentInset
        if let layout = collectionView.collectionViewLayout as? ProjectsCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    func updateView() {
        collectionView.reloadData()
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
        return CGFloat(viewModel.item(at: indexPath)?.users.count ?? 0) * projectCellTableViewHeight + projectCellStaticHeaderHeight
    }
}
