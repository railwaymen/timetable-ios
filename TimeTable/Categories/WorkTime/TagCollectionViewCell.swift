//
//  TagCollectionViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias TagCollectionViewCellable = UICollectionViewCell & TagCollectionViewCellType & TagCollectionViewCellViewModelOutput

protocol TagCollectionViewCellType: class {
    func configure(viewModel: TagCollectionViewCellViewModelType)
}

class TagCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TagReuseIdentifier"
    
    @IBOutlet private var view: AttributedView!
    @IBOutlet private var titleLabel: UILabel!
    
    private var viewModel: TagCollectionViewCellViewModelType!
}

// MARK: - TagCollectionViewCellType
extension TagCollectionViewCell: TagCollectionViewCellType {
    func configure(viewModel: TagCollectionViewCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel.configure()
    }
}

// MARK: - TagCollectionViewCellViewModelOutput
extension TagCollectionViewCell: TagCollectionViewCellViewModelOutput {
    func setUp(title: String?, color: UIColor, isSelected: Bool) {
        self.titleLabel.text = title
        self.titleLabel.textColor = isSelected ? .white : color
        self.view.backgroundColor = isSelected ? color : .clear
        self.view.borderColor = color
    }
}
