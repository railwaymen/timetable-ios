//
//  TagCollectionViewCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol TagCollectionViewCellViewModelType: class {
    func configure()
}

protocol TagCollectionViewCellViewModelOutput: class {
    func setUp(title: String?, color: UIColor, isSelected: Bool)
}

class TagCollectionViewCellViewModel {
    private weak var userInterface: TagCollectionViewCellViewModelOutput?
    private let projectTag: ProjectTag
    private let isSelected: Bool
    
    // MARK: - Initialization
    init(userInterface: TagCollectionViewCellViewModelOutput,
         projectTag: ProjectTag,
         isSelected: Bool) {
        self.userInterface = userInterface
        self.projectTag = projectTag
        self.isSelected = isSelected
    }
}

// MARK: - TagCollectionViewCellViewModelType
extension TagCollectionViewCellViewModel: TagCollectionViewCellViewModelType {
    func configure() {
        self.userInterface?.setUp(title: self.projectTag.localized,
                                  color: self.projectTag.color,
                                  isSelected: self.isSelected)
    }
}
