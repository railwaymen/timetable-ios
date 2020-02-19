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
    func setUpView()
    func updateView(with projectName: String, leaderName: String, projectColor: UIColor)
}

class ProjectCollectionViewCellModel {
    private weak var userInterface: ProjectCollectionViewCellModelOutput?
    private let project: Project
    
    // MARK: - Initialization
    init(
        userInterface: ProjectCollectionViewCellModelOutput?,
        project: Project
    ) {
        self.userInterface = userInterface
        self.project = project
    }
}
 
// MARK: - ProjectCollectionViewCellModelType
extension ProjectCollectionViewCellModel: ProjectCollectionViewCellModelType {
    func configure() {
        self.userInterface?.setUpView()
        self.userInterface?.updateView(with: self.project.name, leaderName: self.project.leader?.name ?? "", projectColor: self.project.color)
    }
    
    func numberOfRows() -> Int {
        return self.project.users.count
    }
    
    func configure(view: ProjectUserViewTableViewCellType, for indexPath: IndexPath) {
        view.configure(withName: self.userName(for: indexPath))
    }
}
 
// MARK: - Private
extension ProjectCollectionViewCellModel {
    private func userName(for indexPath: IndexPath) -> String {
        return self.project.users[safeIndex: indexPath.row]?.name ?? ""
    }
}
