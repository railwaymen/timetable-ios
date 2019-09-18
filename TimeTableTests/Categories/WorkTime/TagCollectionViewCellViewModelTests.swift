//
//  TagCollectionViewCellViewModelTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 13/09/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TagCollectionViewCellViewModelTests: XCTestCase {
    private var userInterfaceMock: TagCollectionViewCellMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = TagCollectionViewCellMock()
    }
    
    func testConfigure() {
        //Arrange
        let tag = ProjectTag.internalMeeting
        let viewModel = self.buildViewModel(tag: tag, isSelected: true)
        //Act
        viewModel.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUp_calledCount, 1)
        XCTAssertEqual(self.userInterfaceMock.setUp_values?.title, tag.localized)
        XCTAssertEqual(self.userInterfaceMock.setUp_values?.color, tag.color)
        XCTAssertTrue(try (self.userInterfaceMock.setUp_values?.isSelected).unwrap())
    }
    
    // MARK: - Private
    private func buildViewModel(tag: ProjectTag = .development, isSelected: Bool = false) -> TagCollectionViewCellViewModel {
        return TagCollectionViewCellViewModel(userInterface: self.userInterfaceMock,
                                              projectTag: tag,
                                              isSelected: isSelected
        )
    }
}

// MARK: - Mocks
// swiftlint:disable large_tuple
private class TagCollectionViewCellMock: TagCollectionViewCellViewModelOutput {
    
    private(set) var setUp_calledCount: Int = 0
    private(set) var setUp_values: (title: String?, color: UIColor, isSelected: Bool)?
    func setUp(title: String?, color: UIColor, isSelected: Bool) {
        self.setUp_calledCount += 1
        self.setUp_values = (title, color, isSelected)
    }
}
// swiftlint:enable large_tuple
