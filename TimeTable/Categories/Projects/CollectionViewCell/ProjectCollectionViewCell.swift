//
//  ProjectCollectionViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol ProjectCollectionViewCellType: class {
    func configure(viewModel: ProjectCollectionViewCellModelType)
}

class ProjectCollectionViewCell: UICollectionViewCell, UITableViewDataSource {
    @IBOutlet private var projectNameLabel: UILabel!
    @IBOutlet private var leaderNameLabel: UILabel!
    @IBOutlet private var projectColorView: AttributedView!
    @IBOutlet private var tableView: UITableView!
    
    private let cellIdentifier = "ProjectUserTableViewCellReuseIdentifier"
    
    private var viewModel: ProjectCollectionViewCellModelType!
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProjectUserViewTableViewCell else {
            return UITableViewCell()
        }
        let name = viewModel.userName(for: indexPath)
        cell.configure(withName: name)
        return cell
    }
}

// MARK: - ProjectCollectionViewCellModelOutput
extension ProjectCollectionViewCell: ProjectCollectionViewCellModelOutput {
    func setupView() {
        tableView.dataSource = self
    }
    
    func updateView(with projectName: String, leaderName: String, projectColor: UIColor) {
        projectNameLabel.text = projectName
        leaderNameLabel.text = leaderName
        projectColorView.backgroundColor = projectColor
    }
}

// MARK: - ProjectCollectionViewCellType
extension ProjectCollectionViewCell: ProjectCollectionViewCellType {
    func configure(viewModel: ProjectCollectionViewCellModelType) {
        self.viewModel = viewModel
        self.viewModel?.configure()
    }
}
