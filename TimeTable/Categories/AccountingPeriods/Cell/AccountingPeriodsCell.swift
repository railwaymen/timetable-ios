//
//  AccountingPeriodsCell.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol AccountingPeriodsCellConfigurationInterface: class {
    func configure(startsAt: String, endsAt: String, isFullTime: Bool, hours: String)
}

class AccountingPeriodsCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var startsAtLabel: UILabel!
    @IBOutlet private var endsAtLabel: UILabel!
    @IBOutlet private var fullTimeLabel: UILabel!
    @IBOutlet private var hoursLabel: UILabel!
}

// MARK: - AccountingPeriodsCellConfigurationInterface
extension AccountingPeriodsCell: AccountingPeriodsCellConfigurationInterface {
    func configure(startsAt: String, endsAt: String, isFullTime: Bool, hours: String) {
        self.startsAtLabel.text = startsAt
        self.endsAtLabel.text = endsAt
        self.fullTimeLabel.alpha = isFullTime ? 1 : 0
        self.hoursLabel.text = hours
    }
}
