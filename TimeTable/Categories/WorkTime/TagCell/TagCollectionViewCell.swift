//
//  TagCollectionViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias TagCollectionViewCellable = UICollectionViewCell & TagCollectionViewCellType & TagCollectionViewCellModelOutput

protocol TagCollectionViewCellType: class {
    func configure(viewModel: TagCollectionViewCellModelType)
}

class TagCollectionViewCell: UICollectionViewCell, ReusableCellType {
    @IBOutlet private var view: AttributedView!
    @IBOutlet private var titleLabel: UILabel!
    
    private var viewModel: TagCollectionViewCellModelType!
}

// MARK: - TagCollectionViewCellType
extension TagCollectionViewCell: TagCollectionViewCellType {
    func configure(viewModel: TagCollectionViewCellModelType) {
        self.viewModel = viewModel
        self.viewModel.configure()
    }
}

// MARK: - TagCollectionViewCellModelOutput
extension TagCollectionViewCell: TagCollectionViewCellModelOutput {
    func setUp(title: String?, color: UIColor, isSelected: Bool) {
        self.titleLabel.text = title
        self.titleLabel.textColor = isSelected ? .white : color
        self.view.backgroundColor = isSelected ? color : .clear
        self.view.borderColor = color
    }
}
