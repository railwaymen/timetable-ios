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
    
    private enum ProjectRecordResponse: String, JSONFileResource {
        case projectRecordResponse
        case projectRecordNullLeaderResponse
        case projectRecordNullUserResponse
    }
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    override func setUp() {
        self.userInterfaceMock = ProjectCollectionViewCellMock()
        do {
            let data = try self.json(from: ProjectRecordResponse.projectRecordResponse)
            let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
            let project = Project(decoder: projectRecord)
            viewModel = ProjectCollectionViewCellModel(userInterface: userInterfaceMock, project: project)
        } catch {
            XCTFail()
        }
        
        super.setUp()
    }
    
    func testConfigureSetUpsView() {
        //Act
        viewModel.configure()
        //Assert
        XCTAssertTrue(userInterfaceMock.setupViewCalled)
    }
    
    func testConfigureUpdateView() {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        //Act
        viewModel.configure()
        //Assert
        XCTAssertTrue(userInterfaceMock.updateViewCalled)
        XCTAssertEqual(userInterfaceMock.updateViewData.leaderName, "Rosalind Auer")
        XCTAssertEqual(userInterfaceMock.updateViewData.projectColor, color)
        XCTAssertEqual(userInterfaceMock.updateViewData.projectName, "Test Name")
    }

    func testConfigureUpdateViewWhileLeaderNameIsNil() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordResponse.projectRecordNullLeaderResponse)
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
        let project = Project(decoder: projectRecord)
        let viewModel = ProjectCollectionViewCellModel(userInterface: userInterfaceMock, project: project)
        let color = UIColor(hexString: "0c0c0c")
        //Act
        viewModel.configure()
        //Assert
        XCTAssertTrue(userInterfaceMock.updateViewCalled)
        XCTAssertEqual(userInterfaceMock.updateViewData.leaderName, "")
        XCTAssertEqual(userInterfaceMock.updateViewData.projectColor, color)
        XCTAssertEqual(userInterfaceMock.updateViewData.projectName, "Test Name")
    }
    
    func testNumberOfRows() {
        //Arrange
        //Act
        let number = viewModel.numberOfRows()
        //Assert
        XCTAssertEqual(number, 1)
    }
    
    func testUserNameReturnsEmptyStringWhileUsersArrayForTheProjectIsEmpty() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordResponse.projectRecordNullUserResponse)
        let projectRecord = try decoder.decode(ProjectRecordDecoder.self, from: data)
        let project = Project(decoder: projectRecord)
        let viewModel = ProjectCollectionViewCellModel(userInterface: userInterfaceMock, project: project)
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
        viewModel.configure(view: cellMock, for: IndexPath(row: 1, section: 0))
        //Assert
        XCTAssertTrue(try (cellMock.configureName?.isEmpty).unwrap())
    }
    
    func testUserNameReturnsSucceed() throws {
        //Arrange
        let cellMock = ProjectUserViewTableViewCellMock()
        //Act
        viewModel.configure(view: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureName, "Admin Admin")
    }
}

private class ProjectUserViewTableViewCellMock: ProjectUserViewTableViewCellType {
    
    private(set) var configureName: String?
    func configure(withName name: String) {
        self.configureName = name
    }
}
