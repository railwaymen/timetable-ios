//
//  TagCollectionCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol TagCollectionCellViewModelType: class {
    func configure()
}

protocol TagCollectionCellViewModelOutput: class {
    func setUp(title: String, color: UIColor, isSelected: Bool)
}

class TagCollectionCellViewModel: TagCollectionCellViewModelType {
    private weak var userInterface: TagCollectionCellViewModelOutput?
    private let projectTag: ProjectTag
    private let isSelected: Bool
    
    // MARK: - Initialization
    init(userInterface: TagCollectionCellViewModelOutput,
         projectTag: ProjectTag,
         isSelected: Bool) {
        self.userInterface = userInterface
        self.projectTag = projectTag
        self.isSelected = isSelected
    }
    
    // MARK: - TagCollectionCellViewModelType
    func configure() {
        self.userInterface?.setUp(title: self.projectTag.localized,
                                  color: self.projectTag.color,
                                  isSelected: self.isSelected)
    }
}
