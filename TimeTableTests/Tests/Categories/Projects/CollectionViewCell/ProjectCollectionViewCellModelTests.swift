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
        self.userInterfaceMock = ProjectCollectionViewCellMock()
        super.setUp()
    }
}

// MARK: - configure()
extension ProjectCollectionViewCellModelTests {
    func testConfigureSetUpsView() throws {
        //Arrange
        let sut = try self.buildSUT()
        //Act
        sut.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
    }
    
    func testConfigureUpdateView() throws {
        //Arrange
        let sut = try self.buildSUT()
        let color = UIColor(hexString: "0c0c0c")
        //Act
        sut.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.leaderName, "Rosalind Auer")
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.projectColor, color)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.projectName, "Test Name")
    }

    func testConfigureUpdateViewWhileLeaderNameIsNil() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullLeaderResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        let project = Project(decoder: projectRecord)
        let sut = try self.buildSUT(project: project)
        let color = UIColor(hexString: "0c0c0c")
        //Act
        sut.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.leaderName, "")
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
        XCTAssertEqual(number, 1)
    }
}

// MARK: - configure(view: ProjectUserViewTableViewCellType, for indexPath: IndexPath)
extension ProjectCollectionViewCellModelTests {
    func testUserNameReturnsEmptyStringWhileUsersArrayForTheProjectIsEmpty() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUserResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        let project = Project(decoder: projectRecord)
        let sut = try self.buildSUT(project: project)
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        sut.configure(view: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertTrue(try XCTUnwrap(cellMock.configureParams.last?.name.isEmpty))
    }
    
    func testUserNameReturnsEmptyStringWhileIndexPathIsOutOfTheRange() throws {
        //Arrange
        let sut = try self.buildSUT()
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        sut.configure(view: cellMock, for: IndexPath(row: 1, section: 0))
        //Assert
        XCTAssertTrue(try XCTUnwrap(cellMock.configureParams.last?.name.isEmpty))
    }
    
    func testUserNameReturnsSucceed() throws {
        //Arrange
        let sut = try self.buildSUT()
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        sut.configure(view: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureParams.last?.name, "Admin Admin")
    }
}

// MARK: - Private
extension ProjectCollectionViewCellModelTests {
    private func buildSUT(project: Project? = nil) throws -> ProjectCollectionViewCellModel {
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        let defaultProject = Project(decoder: projectRecord)
        return ProjectCollectionViewCellModel(
            userInterface: self.userInterfaceMock,
            project: project ?? defaultProject)
    }
}
