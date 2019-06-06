//
//  TagCollectionViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol TagCollectionViewCellType: class {
    func configure(viewModel: TagCollectionCellViewModelType)
}

class TagCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TagReuseIdentifier"
    
    @IBOutlet private var view: AttributedView!
    @IBOutlet private var titleLabel: UILabel!
    
    private var viewModel: TagCollectionCellViewModelType!
}

// MARK: - TagCollectionViewCellType
extension TagCollectionViewCell: TagCollectionViewCellType {
    func configure(viewModel: TagCollectionCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel.configure()
    }
}

// MARK: - TagCollectionCellViewModelOutput
extension TagCollectionViewCell: TagCollectionCellViewModelOutput {
    func setUp(title: String, color: UIColor, isSelected: Bool) {
        self.titleLabel.text = title
        self.titleLabel.textColor = isSelected ? .white : color
        self.view.backgroundColor = isSelected ? color : .white
        self.view.borderColor = isSelected ? .white : color
    }
}
