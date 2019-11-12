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
