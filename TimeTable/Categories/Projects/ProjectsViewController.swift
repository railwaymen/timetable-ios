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

class ProjectsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private var collectionView: UICollectionView!
    private let cellIdentifier = "ProjectCollectionViewCellReuseIdentifier"
    private var viewModel: ProjectsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let project = viewModel.item(at: indexPath)
        let cellViewModel = ProjectCollectionViewCellModel(userInterface: cell, project: project)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension ProjectsViewController: ProjectsViewModelOutput {
    
}

extension ProjectsViewController: ProjectsViewControllerType {
    func configure(viewModel: ProjectsViewModelType) {
        self.viewModel = viewModel
    }
}
