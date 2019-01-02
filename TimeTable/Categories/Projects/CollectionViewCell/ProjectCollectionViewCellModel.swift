//
//  ProjectCollectionViewCellModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ProjectCollectionViewCellModelType: class {
    func prepareForReuse()
    func numberOfRows() -> Int
}

protocol ProjectCollectionViewCellModelOutput: class {
    func setupView()
}

class ProjectCollectionViewCellModel: ProjectCollectionViewCellModelType {
    private weak var userInterface: ProjectCollectionViewCellModelOutput?
    private let project: Project
    
    // MARK: - Initialization
    init(userInterface: ProjectCollectionViewCellModelOutput?, project: Project) {
        self.userInterface = userInterface
        self.project = project
    }
    
    // MARK: - ProjectCollectionViewCellModelType
    func prepareForReuse() {
        userInterface?.setupView()
    }
    
    func numberOfRows() -> Int {
        return project.users.count
    }
}
