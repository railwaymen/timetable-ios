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
    private var viewModel: ProjectCollectionViewCellModel!
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    override func setUp() {
        self.userInterfaceMock = ProjectCollectionViewCellMock()
        do {
            let data = try self.json(from: ProjectRecordJSONResource.projectRecordResponse)
            let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
            let project = Project(decoder: projectRecord)
            self.viewModel = ProjectCollectionViewCellModel(userInterface: self.userInterfaceMock, project: project)
        } catch {
            XCTFail()
        }
        
        super.setUp()
    }
    
    func testConfigureSetUpsView() {
        //Act
        self.viewModel.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
    }
    
    func testConfigureUpdateView() {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        //Act
        self.viewModel.configure()
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
        let viewModel = ProjectCollectionViewCellModel(userInterface: self.userInterfaceMock, project: project)
        let color = UIColor(hexString: "0c0c0c")
        //Act
        viewModel.configure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.leaderName, "")
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.projectColor, color)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.last?.projectName, "Test Name")
    }
    
    func testNumberOfRows() {
        //Arrange
        //Act
        let number = self.viewModel.numberOfRows()
        //Assert
        XCTAssertEqual(number, 1)
    }
    
    func testUserNameReturnsEmptyStringWhileUsersArrayForTheProjectIsEmpty() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectRecordNullUserResponse)
        let projectRecord = try self.decoder.decode(ProjectRecordDecoder.self, from: data)
        let project = Project(decoder: projectRecord)
        let viewModel = ProjectCollectionViewCellModel(userInterface: self.userInterfaceMock, project: project)
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        viewModel.configure(view: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertTrue(try (cellMock.configureName?.isEmpty).unwrap())
    }
    
    func testUserNameReturnsEmptyStringWhileIndexPathIsOutOfTheRange() throws {
        //Arrange
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        self.viewModel.configure(view: cellMock, for: IndexPath(row: 1, section: 0))
        //Assert
        XCTAssertTrue(try (cellMock.configureName?.isEmpty).unwrap())
    }
    
    func testUserNameReturnsSucceed() throws {
        //Arrange
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        self.viewModel.configure(view: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureName, "Admin Admin")
    }
}
