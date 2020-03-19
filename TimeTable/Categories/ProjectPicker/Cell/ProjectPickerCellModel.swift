//
//  ProjectPickerCellModel.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ProjectPickerCellModelOutput: class {
    func setUp(title: String)
}

protocol ProjectPickerCellModelType: class {
    func viewDidConfigure()
}

class ProjectPickerCellModel {
    private weak var userInterface: ProjectPickerCellModelOutput?
    private let project: SimpleProjectRecordDecoder
    
    // MARK: - Initialization
    init(
        userInterface: ProjectPickerCellModelOutput?,
        project: SimpleProjectRecordDecoder
    ) {
        self.userInterface = userInterface
        self.project = project
    }
}

// MARK: - ProjectPickerCellModelType
extension ProjectPickerCellModel: ProjectPickerCellModelType {
    func viewDidConfigure() {
        self.userInterface?.setUp(title: self.project.name)
    }
}
