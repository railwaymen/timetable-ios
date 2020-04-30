//
//  AccountingPeriodsCell.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol AccountingPeriodsCellConfigurationInterface: class {
    func configure(with config: AccountingPeriodsCell.Config)
}

class AccountingPeriodsCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var startsAtLabel: UILabel!
    @IBOutlet private var endsAtLabel: UILabel!
    @IBOutlet private var hoursLabel: UILabel!
    @IBOutlet private var fullTimeLabel: UILabel!
    @IBOutlet private var closedImageView: UIImageView!
    @IBOutlet private var noteLabel: UILabel!
    @IBOutlet private var noteStackView: UIStackView!
}

// MARK: - Structures
extension AccountingPeriodsCell {
    struct Config {
        let startsAt: String
        let endsAt: String
        let hours: String
        let hoursColor: UIColor
        let note: String
        let isFullTime: Bool
        let isClosed: Bool
    }
}

// MARK: - AccountingPeriodsCellConfigurationInterface
extension AccountingPeriodsCell: AccountingPeriodsCellConfigurationInterface {
    func configure(with config: Config) {
        self.startsAtLabel.text = config.startsAt
        self.endsAtLabel.text = config.endsAt
        self.hoursLabel.text = config.hours
        self.hoursLabel.textColor = config.hoursColor
        self.fullTimeLabel.text = config.isFullTime
            ? R.string.localizable.accountingperiods_full_time_yes()
            : R.string.localizable.accountingperiods_full_time_no()
        self.noteLabel.text = config.note
        
        let closedImageShouldBeHidden = !config.isClosed
        let noteShouldBeHidden = config.note.isEmpty
        self.closedImageView.set(isHidden: closedImageShouldBeHidden)
        self.noteLabel.alpha = noteShouldBeHidden ? 0 : 1
        self.noteStackView.set(isHidden: noteShouldBeHidden && closedImageShouldBeHidden)
    }
}
