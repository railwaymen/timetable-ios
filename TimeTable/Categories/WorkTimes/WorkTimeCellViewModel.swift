//
//  WorkTimesCellViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 23/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol WorkTimeCellViewModelOutput: class {
    
}

protocol WorkTimeCellViewModelType: class {
    func prepareForReuse()
    func viewRequestedForTaskPreview()
}

class WorkTimeCellViewModel: WorkTimeCellViewModelType {

    private let workTime: WorkTimeDecoder
    
    // MARK: - Initialization
    init(workTime: WorkTimeDecoder) {
        self.workTime = workTime
    }
    
    // MARK: - WorkTimeCellViewModelType
    func prepareForReuse() {
        
    }
    
    func viewRequestedForTaskPreview() {
        
    }
}
