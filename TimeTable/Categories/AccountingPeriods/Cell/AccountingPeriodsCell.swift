//
//  AccountingPeriodsCell.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 27/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

protocol AccountingPeriodsCellConfigurationInterface: class {
    func configure(startsAt: String, endsAt: String, hours: String, note: String, isFullTime: Bool, isClosed: Bool)
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

// MARK: - AccountingPeriodsCellConfigurationInterface
extension AccountingPeriodsCell: AccountingPeriodsCellConfigurationInterface {
    func configure(startsAt: String, endsAt: String, hours: String, note: String, isFullTime: Bool, isClosed: Bool) {
        self.startsAtLabel.text = startsAt
        self.endsAtLabel.text = endsAt
        self.hoursLabel.text = hours
        self.fullTimeLabel.text = isFullTime
            ? R.string.localizable.accountingperiods_full_time_yes()
            : R.string.localizable.accountingperiods_full_time_no()
        self.noteLabel.text = note
        
        let closedImageShouldBeHidden = !isClosed
        let noteShouldBeHidden = note.isEmpty
        self.closedImageView.set(isHidden: closedImageShouldBeHidden)
        self.noteLabel.alpha = noteShouldBeHidden ? 0 : 1
        self.noteStackView.set(isHidden: noteShouldBeHidden && closedImageShouldBeHidden)
    }
}
