//
//  ProjectPickerCell.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import UIKit

typealias ProjectPickerCellable = UITableViewCell & ProjectPickerCellType & ProjectPickerCellModelOutput

protocol ProjectPickerCellType: class {
    func configure(viewModel: ProjectPickerCellModelType)
}

class ProjectPickerCell: UITableViewCell {
    static let reuseIdentifier = "ProjectPickerCellReuseIdentifier"
    
    @IBOutlet private var titleLabel: UILabel!

    private var viewModel: ProjectPickerCellModelType!
}

// MARK: - ProjectPickerCellModelOutput
extension ProjectPickerCell: ProjectPickerCellModelOutput {
    func setUp(title: String) {
        titleLabel.text = title
    }
}

// MARK: - ProjectPickerCellType
extension ProjectPickerCell: ProjectPickerCellType {
    func configure(viewModel: ProjectPickerCellModelType) {
        self.viewModel = viewModel
        viewModel.viewDidConfigure()
    }
}
