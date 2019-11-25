//
//  ProjectsViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectsViewModelTests: XCTestCase {
    private var userInterfaceMock: ProjectsViewControllerMock!
    private var apiClientMock: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
        
    override func setUp() {
        self.userInterfaceMock = ProjectsViewControllerMock()
        self.apiClientMock = ApiClientMock()
        self.errorHandlerMock = ErrorHandlerMock()
        super.setUp()
    }
    
    func testNumberOfItemsOnInitializationReturnsZero() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let numberOfItems = sut.numberOfItems()
        //Assert
        XCTAssertEqual(numberOfItems, 0)
    }
    
    func testNuberOfItemsAfterViewDidLoadReturnsMoreThanZero() throws {
        //Arrange
        let data = try self.json(from: ProjectRecordJSONResource.projectsRecordsResponse)
        let records = try self.decoder.decode([ProjectRecordDecoder].self, from: data)
        let sut = self.buildSUT()
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.success(records))
        //Act
        let numberOfItems = sut.numberOfItems()
        //Assert
        XCTAssertEqual(numberOfItems, 2)
    }
    
    func testItemAtIndexOnInitializationReturnsNil() {
        //Arrange
        let sut = self.buildSUT()
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        let project = sut.item(at: indexPath)
        //Assert
        XCTAssertNil(project)
    }
    
    func testItemAtIndexAfterViewDidLoadReturnsProjectForFirstRow() throws {
        //Arrange
        let color = UIColor(hexString: "00000c")
        let user = Project.User(name: "John Test")
        let leader = Project.User(name: "Leader Leader")
        let data = try self.json(from: ProjectRecordJSONResource.projectsRecordsResponse)
        let records = try self.decoder.decode([ProjectRecordDecoder].self, from: data)
        let sut = self.buildSUT()
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.success(records))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        let project = sut.item(at: indexPath)
        //Assert
        XCTAssertEqual(project?.name, "Test Test")
        XCTAssertEqual(project?.color, color)
        XCTAssertEqual(project?.identifier, 12)
        XCTAssertEqual(project?.users.count, 1)
        XCTAssertEqual(try (project?.users.first).unwrap(), user)
        XCTAssertEqual(project?.leader, leader)
    }
    
    func testItemAtIndexAfterViewDidLoadReturnsProjectForSecondRow() throws {
        //Arrange
        let color = UIColor(hexString: "0c0c0c")
        let firstUser = Project.User(name: "User User")
        let lastUser = Project.User(name: "Admin Admin")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectRecordJSONResource.projectsRecordsResponse)
        let records = try self.decoder.decode([ProjectRecordDecoder].self, from: data)
        let sut = self.buildSUT()
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.success(records))
        let indexPath = IndexPath(row: 1, section: 0)
        //Act
        let project = sut.item(at: indexPath)
        //Assert
        XCTAssertEqual(project?.name, "Test Name")
        XCTAssertEqual(project?.identifier, 11)
        XCTAssertEqual(project?.color, color)
        XCTAssertEqual(project?.users.count, 2)
        XCTAssertEqual(try (project?.users.first).unwrap(), firstUser)
        XCTAssertEqual(try (project?.users.last).unwrap(), lastUser)
        XCTAssertEqual(project?.leader, leader)
    }
    
    func testViewDidLoadSetUpsView() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
    }
    
    func testViewDidLoadFetchProjectsFailure() throws {
        //Arrange
        let error = TestError(message: "fetch project failure")
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(try (self.errorHandlerMock.throwingParams.last?.error as? TestError).unwrap(), error)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try (self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden).unwrap())
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
    
}

// MARK: - Private
extension ProjectsViewModelTests {
    private func buildSUT() -> ProjectsViewModel {
        return ProjectsViewModel(
            userInterface: self.userInterfaceMock,
            apiClient: self.apiClientMock,
            errorHandler: self.errorHandlerMock)
    }
}
