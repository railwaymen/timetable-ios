//
//  WorkTimeStandardTableViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

class WorkTimeStandardTableViewCell: WorkTimeTableViewCell {}

// MARK: - WorkTimeCellViewModelOutput
extension WorkTimeStandardTableViewCell: WorkTimeCellViewModelOutput {
    func updateView(durationText: String?, bodyText: String?, taskUrlText: String?, fromToDateText: String?, projectTitle: String?, projectColor: UIColor?) {
        self.update(durationText: durationText, bodyText: bodyText, fromToDateText: fromToDateText, projectTitle: projectTitle, projectColor: projectColor)
    }
}
