//
//  TagCollectionViewCellModelTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 13/09/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class TagCollectionViewCellModelTests: XCTestCase {
    private var userInterfaceMock: TagCollectionViewCellMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = TagCollectionViewCellMock()
    }
    
    func testConfigure() {
        //Arrange
        let tag = ProjectTag.internalMeeting
        let sut = self.buildSUT(tag: tag, isSelected: true)
        //Act
        sut.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.title, tag.localized)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.color, tag.color)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setUpParams.last?.isSelected))
    }
}

// MARK: - Private
extension TagCollectionViewCellModelTests {
    private func buildSUT(tag: ProjectTag = .development, isSelected: Bool = false) -> TagCollectionViewCellModel {
        return TagCollectionViewCellModel(
            userInterface: self.userInterfaceMock,
            projectTag: tag,
            isSelected: isSelected)
    }
}
