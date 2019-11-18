//
//  TagCollectionViewCellMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TagCollectionViewCellMock: UICollectionViewCell {
    private(set) var setUpParams: [SetUpParams] = []
    struct SetUpParams {
        var title: String?
        var color: UIColor
        var isSelected: Bool
    }
    
    private(set) var configureParams: [ConfigureParams] = []
    struct ConfigureParams {
        var viewModel: TagCollectionViewCellViewModelType
    }
}

// MARK: - TagCollectionViewCellViewModelOutput
extension TagCollectionViewCellMock: TagCollectionViewCellViewModelOutput {
    func setUp(title: String?, color: UIColor, isSelected: Bool) {
        self.setUpParams.append(SetUpParams(title: title, color: color, isSelected: isSelected))
    }
}

// MARK: - TagCollectionViewCellType
extension TagCollectionViewCellMock: TagCollectionViewCellType {
    func configure(viewModel: TagCollectionViewCellViewModelType) {
        self.configureParams.append(ConfigureParams(viewModel: viewModel))
    }
}
