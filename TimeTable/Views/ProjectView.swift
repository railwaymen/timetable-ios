//
//  ProjectView.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 31/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import UIKit

protocol ProjectViewType: class {
    func setUp(data: ProjectView.ProjectData?)
}

class ProjectView: AttributedView, ProjectViewType {
    
    @IBOutlet private var titleLabel: UILabel!
    
    struct ProjectData {
        let title: String?
        let color: UIColor?
    }
    
    // MARK: - ProjectViewType
    func setUp(data: ProjectData?) {
        self.backgroundColor = data?.color
        titleLabel.text = data?.title
    }
}
