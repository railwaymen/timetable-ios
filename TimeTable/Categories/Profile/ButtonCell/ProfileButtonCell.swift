//
//  ProfileButtonCell.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 22/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol ProfileButtonCellConfigurationInterface: class {
    func configure(text: String)
}

class ProfileButtonCell: UITableViewCell, ReusableCellType {
    static let nibName: String = R.nib.profileButtonCell.name
    
    @IBOutlet private var label: UILabel!
}

// MARK: - ProfileButtonCellConfigurationInterface
extension ProfileButtonCell: ProfileButtonCellConfigurationInterface {
    func configure(text: String) {
        self.label.text = text
        self.label.textColor = .tint
    }
}
