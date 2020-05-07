//
//  RemoteWorkCell.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/05/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import UIKit

typealias RemoteWorkCellable = (RemoteWorkCellType & RemoteWorkCellViewModelOutput)

protocol RemoteWorkCellType: class {
    func configure(viewModel: RemoteWorkCellViewModelType)
}

class RemoteWorkCell: UITableViewCell, ReusableCellType {
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var timeIntervalLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var noteLabel: UILabel!
    
    private var viewModel: RemoteWorkCellViewModelType!
}

// MAKR: - RemoteWorkCellViewModelOutput
extension RemoteWorkCell: RemoteWorkCellViewModelOutput {
    
}

// MARK: - RemoteWorkCellType
extension RemoteWorkCell: RemoteWorkCellType {
    func configure(viewModel: RemoteWorkCellViewModelType) {
        self.viewModel = viewModel
        self.viewModel.viewConfigured()
    }
}
