//
//  ProfileHeaderView.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewConfigurationInterface: class {
    func configure(name: String, email: String)
}

class ProfileHeaderView: UIView {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
}

// MARK: - ProfileHeaderViewConfigurationInterface
extension ProfileHeaderView: ProfileHeaderViewConfigurationInterface {
    func configure(name: String, email: String) {
        self.nameLabel.text = name
        self.emailLabel.text = email
    }
}
