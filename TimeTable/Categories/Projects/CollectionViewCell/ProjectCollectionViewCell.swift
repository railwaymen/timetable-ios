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
    
    private var viewModel: ProjectCollectionViewCellModelType!
    
    // MARK: - Overriden
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.prepareForReuse()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ProjectCollectionViewCell: ProjectCollectionViewCellModelOutput {
    func setupView() {
        tableView.dataSource = self
    }
}

extension ProjectCollectionViewCell: ProjectCollectionViewCellType {
    func configure(viewModel: ProjectCollectionViewCellModelType) {
        self.viewModel = viewModel
    }
}
