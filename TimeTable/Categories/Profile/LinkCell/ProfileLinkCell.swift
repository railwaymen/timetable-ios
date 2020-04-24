//
//  ProfileLinkCell.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 24/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol ProfileLinkCellConfigurationInterface: class {
    func configure(text: String)
}

class ProfileLinkCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var titleLabel: UILabel!
}

// MARK: - ProfileLinkCellConfigurationInterface
extension ProfileLinkCell: ProfileLinkCellConfigurationInterface {
    func configure(text: String) {
        self.titleLabel.text = text
    }
}
