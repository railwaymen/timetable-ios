//
//  WorkTimesCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeCellViewModelOutput: class {
    func updateView(durationText: String?, bodyText: String?, taskText: String?, fromToDateText: String?)
}

protocol WorkTimeCellViewModelType: class {
    func viewConfigured()
    func prepareForReuse()
    func viewRequestedForTaskPreview()
}

class WorkTimeCellViewModel: WorkTimeCellViewModelType {

    private let workTime: WorkTimeDecoder
    private weak var userInterface: WorkTimeCellViewModelOutput?
    
    // MARK: - Initialization
    init(workTime: WorkTimeDecoder, userInterface: WorkTimeCellViewModelOutput) {
        self.workTime = workTime
        self.userInterface = userInterface
    }
    
    // MARK: - WorkTimeCellViewModelType
    func viewConfigured() {
        self.updateView()
    }
    
    func prepareForReuse() {
        self.updateView()
    }
    
    func viewRequestedForTaskPreview() {
        
    }
    
    // MARK: - Private
    private func updateView() {
        let duration = TimeInterval(workTime.duration)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        let durationText = formatter.string(from: duration)
        
        let startsAtText = DateFormatter.localizedString(from: workTime.startsAt, dateStyle: .none, timeStyle: .short)
        let endsAtText = DateFormatter.localizedString(from: workTime.endsAt, dateStyle: .none, timeStyle: .short)
        let fromToDateText = "\(startsAtText) - \(endsAtText)"
        
        userInterface?.updateView(durationText: durationText, bodyText: workTime.body, taskText: workTime.taskPreview, fromToDateText: fromToDateText)
    }
}
