//
//  ProjectUserViewTableViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias ProjectUserViewTableViewCellable = UITableViewCell & ProjectUserViewTableViewCellType

protocol ProjectUserViewTableViewCellType: class {
    func configure(withName name: String)
}

class ProjectUserViewTableViewCell: UITableViewCell {
    @IBOutlet private var userNameLabel: UILabel!
}

// MARK: - ProjectUserViewTableViewCellType
extension ProjectUserViewTableViewCell: ProjectUserViewTableViewCellType {
    func configure(withName name: String) {
        userNameLabel.text = name
    }
}
