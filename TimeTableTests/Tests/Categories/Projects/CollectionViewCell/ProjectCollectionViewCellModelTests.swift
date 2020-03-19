//
//  ProjectCollectionViewCellModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectCollectionViewCellModelTests: XCTestCase {
    private var userInterfaceMock: ProjectCollectionViewCellMock!
        
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProjectCollectionViewCellMock()
    }
}

// MARK: - configure()
extension ProjectCollectionViewCellModelTests {
    func testConfigure_setsUpUI() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        sut.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
    }
    
    func testConfigure_updatesUI() throws {
        //Arrange
        let sut = try self.buildSUT()
        let color = UIColor(hexString: "0c0c0c")
        //Act
        sut.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.leaderName, "Leader Best")
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.projectColor, color)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.projectName, "Test Name")
    }
}

// MARK: - numberOfRows() -> Int
extension ProjectCollectionViewCellModelTests {
    func testNumberOfRows() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        let number = sut.numberOfRows()
        //Assert
        XCTAssertEqual(number, 3)
    }
}

// MARK: - configure(view:for:)
extension ProjectCollectionViewCellModelTests {
    func testConfigureCell_withUsersArrayEmpty_setsEmptyName() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUsersResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        let sut = try self.buildSUT(project: projectRecord)
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        sut.configure(view: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertTrue(try XCTUnwrap(cellMock.configureParams.last?.name.isEmpty))
    }
    
    func testConfigureCell_withIndexOutOfBounds_setsEmptyName() throws {
        //Arrange
        let sut = try self.buildSUT()
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        sut.configure(view: cellMock, for: IndexPath(row: 100, section: 0))
        //Assert
        XCTAssertTrue(try XCTUnwrap(cellMock.configureParams.last?.name.isEmpty))
    }
    
    func testConfigure_indexInBounds_setsProperName() throws {
        //Arrange
        let sut = try self.buildSUT()
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        sut.configure(view: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureParams.last?.name, "John Smith")
    }
}

// MARK: - Private
extension ProjectCollectionViewCellModelTests {
    private func buildSUT(project: ProjectRecordDecoder? = nil) throws -> ProjectCollectionViewCellModel {
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        return ProjectCollectionViewCellModel(
            userInterface: self.userInterfaceMock,
            project: project ?? projectRecord)
    }
}
