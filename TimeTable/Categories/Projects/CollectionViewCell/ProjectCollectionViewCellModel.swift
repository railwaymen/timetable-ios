//
//  ProjectCollectionViewCellModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import UIKit

protocol ProjectCollectionViewCellModelType: class {
    func configure()
    func numberOfRows() -> Int
    func configure(view: ProjectUserViewTableViewCellType, for indexPath: IndexPath)
}

protocol ProjectCollectionViewCellModelOutput: class {
    func setupView()
    func updateView(with projectName: String, leaderName: String, projectColor: UIColor)
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
    func configure() {
        userInterface?.setupView()
        userInterface?.updateView(with: project.name, leaderName: project.leader?.name ?? "", projectColor: project.color)
    }
    
    func numberOfRows() -> Int {
        return project.users.count
    }
    
    func configure(view: ProjectUserViewTableViewCellType, for indexPath: IndexPath) {
        view.configure(withName: userName(for: indexPath))
    }
    
    // MARK: - Private
    private func userName(for indexPath: IndexPath) -> String {
        guard project.users.count > indexPath.row else { return "" }
        return project.users[indexPath.row].name
    }
}
