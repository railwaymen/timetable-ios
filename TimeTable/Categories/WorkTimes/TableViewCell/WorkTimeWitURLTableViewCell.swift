//
//  WorkTimeWitURLTableViewCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

class WorkTimeWitURLTableViewCell: WorkTimeTableViewCell {
    @IBOutlet private var taskButton: UIButton!
    
    // MARK: - IBAction
    @IBAction private func taskButtonTapped(_ sender: UIButton) {
        // TO_DO: - redirect to task preview
    }
}

// MARK: - WorkTimeCellViewModelOutput
extension WorkTimeWitURLTableViewCell: WorkTimeCellViewModelOutput {
    func updateView(durationText: String?, bodyText: String?, taskUrlText: String?, fromToDateText: String?, projectTitle: String?, projectColor: UIColor?) {
        self.update(durationText: durationText, bodyText: bodyText, fromToDateText: fromToDateText, projectTitle: projectTitle, projectColor: projectColor)
        self.taskButton?.setTitle(taskUrlText, for: .normal)
    }
}
