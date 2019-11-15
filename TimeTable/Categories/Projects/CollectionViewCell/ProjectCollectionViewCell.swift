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

class ProjectCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private var attributedBackgroundView: AttributedView!
    @IBOutlet private var projectNameLabel: UILabel!
    @IBOutlet private var leaderNameLabel: UILabel!
    @IBOutlet private var projectColorView: AttributedView!
    @IBOutlet private var tableView: UITableView!
    
    private let cellIdentifier = "ProjectUserTableViewCellReuseIdentifier"
    
    private var viewModel: ProjectCollectionViewCellModelType!
    private lazy var shadowLayer = self.generateShadowLayer()
    
    // MARK: - Overridden
    override func layoutSubviews() {
        self.shadowLayer.frame = self.bounds
        let cornerRadius = self.attributedBackgroundView.layer.cornerRadius
        self.shadowLayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        super.layoutSubviews()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? ProjectUserViewTableViewCellable else {
            return UITableViewCell()
        }
        self.viewModel.configure(view: cell, for: indexPath)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
    
    // MARK: - Private
    private func generateShadowLayer() -> CALayer {
        let cornerRadius = self.attributedBackgroundView.layer.cornerRadius
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = self.bounds
        shadowLayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.shadowColor = UIColor.defaultLabel.cgColor
        shadowLayer.shadowOpacity = 0.07
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowRadius = 4
        shadowLayer.masksToBounds = false
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }
}

// MARK: - ProjectCollectionViewCellModelOutput
extension ProjectCollectionViewCell: ProjectCollectionViewCellModelOutput {
    func setUpView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func updateView(with projectName: String, leaderName: String, projectColor: UIColor) {
        self.projectNameLabel.text = projectName
        self.leaderNameLabel.text = leaderName
        self.projectColorView.backgroundColor = projectColor
    }
}

// MARK: - ProjectCollectionViewCellType
extension ProjectCollectionViewCell: ProjectCollectionViewCellType {
    func configure(viewModel: ProjectCollectionViewCellModelType) {
        self.viewModel = viewModel
        viewModel.configure()
    }
}
