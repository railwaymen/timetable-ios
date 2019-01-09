//
//  ProjectButton.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

protocol ProjectButtonType: class {
    func setUp(data: ProjectButton.ProjectData?)
}

class ProjectButton: AttributedButton, ProjectButtonType {
    
    struct ProjectData {
        let title: String?
        let color: UIColor?
    }
    
    // MARK: - ProjectViewType
    func setUp(data: ProjectData?) {
        self.backgroundColor = data?.color
        setTitle(data?.title, for: .normal)
    }
}
