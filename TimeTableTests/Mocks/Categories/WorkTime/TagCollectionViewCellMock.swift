//
//  TagCollectionViewCellMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 12/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

// swiftlint:disable large_tuple
class TagCollectionViewCellMock: TagCollectionViewCellable {
    
    // MARK: - TagCollectionViewCellViewModelOutput
    private(set) var setUp_calledCount: Int = 0
    private(set) var setUp_values: (title: String?, color: UIColor, isSelected: Bool)?
    func setUp(title: String?, color: UIColor, isSelected: Bool) {
        self.setUp_calledCount += 1
        self.setUp_values = (title, color, isSelected)
    }
    
    // MARK: - TagCollectionViewCellType
    func configure(viewModel: TagCollectionViewCellViewModelType) {
        
    }
}
// swiftlint:enable large_tuple
