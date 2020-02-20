//
//  TagCollectionViewCellModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 29/05/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol TagCollectionViewCellModelType: class {
    func configure()
}

protocol TagCollectionViewCellModelOutput: class {
    func setUp(title: String?, color: UIColor, isSelected: Bool)
}

class TagCollectionViewCellModel {
    private weak var userInterface: TagCollectionViewCellModelOutput?
    private let projectTag: ProjectTag
    private let isSelected: Bool
    
    // MARK: - Initialization
    init(
        userInterface: TagCollectionViewCellModelOutput,
        projectTag: ProjectTag,
        isSelected: Bool
    ) {
        self.userInterface = userInterface
        self.projectTag = projectTag
        self.isSelected = isSelected
    }
}

// MARK: - TagCollectionViewCellModel
extension TagCollectionViewCellModel: TagCollectionViewCellModelType {
    func configure() {
        self.userInterface?.setUp(
            title: self.projectTag.localized,
            color: self.projectTag.color,
            isSelected: self.isSelected)
    }
}
