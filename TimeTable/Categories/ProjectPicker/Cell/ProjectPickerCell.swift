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

class ProjectPickerCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var colorView: UIView!
    @IBOutlet private var titleLabel: UILabel!

    private var viewModel: ProjectPickerCellModelType!
}

// MARK: - ProjectPickerCellModelOutput
extension ProjectPickerCell: ProjectPickerCellModelOutput {
    func setUp(title: String, color: UIColor) {
        self.titleLabel.text = title
        self.colorView.backgroundColor = color
    }
}

// MARK: - ProjectPickerCellType
extension ProjectPickerCell: ProjectPickerCellType {
    func configure(viewModel: ProjectPickerCellModelType) {
        self.viewModel = viewModel
        viewModel.viewDidConfigure()
    }
}
