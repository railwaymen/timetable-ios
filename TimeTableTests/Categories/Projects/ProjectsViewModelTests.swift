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
    private var viewModel: ProjectsViewModel!
    
    private enum ProjectsRecordsResponse: String, JSONFileResource {
        case projectsRecordsResponse
    }
    
    private var decoder: JSONDecoder = JSONDecoder()
    
    override func setUp() {
        userInterfaceMock = ProjectsViewControllerMock()
        apiClientMock = ApiClientMock()
        errorHandlerMock = ErrorHandlerMock()
        viewModel = ProjectsViewModel(userInterface: userInterfaceMock, apiClient: apiClientMock, errorHandler: errorHandlerMock)
        super.setUp()
    }
    
    func testNumberOfItemsOnInitializationReturnsZero() {
        //Act
        let numberOfItems = viewModel.numberOfItems()
        //Assert
        XCTAssertEqual(numberOfItems, 0)
    }
    
    func testNuberOfItemsAfterViewDidLoadReturnsMoreThanZero() throws {
        //Arrange
        let data = try self.json(from: ProjectsRecordsResponse.projectsRecordsResponse)
        let records = try decoder.decode([ProjectRecordDecoder].self, from: data)
        viewModel.viewDidLoad()
        apiClientMock.fetchAllProjectsCompletion?(.success(records))
        //Act
        let numberOfItems = viewModel.numberOfItems()
        //Assert
        XCTAssertEqual(numberOfItems, 2)
    }
    
    func testItemAtIndexOnInitializationRetursNil() {
        //Arrange
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        let project = viewModel.item(at: indexPath)
        //Assert
        XCTAssertNil(project)
    }
    
    func testItemAtIndexAfterViewDidLoadRetrunsProjectForFirstRow() throws {
        //Arrange
        let color = UIColor(string: "00000c")
        let user = Project.User(name: "John Test")
        let leader = Project.User(name: "Leader Leader")
        let data = try self.json(from: ProjectsRecordsResponse.projectsRecordsResponse)
        let records = try decoder.decode([ProjectRecordDecoder].self, from: data)
        viewModel.viewDidLoad()
        apiClientMock.fetchAllProjectsCompletion?(.success(records))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        let project = viewModel.item(at: indexPath)
        //Assert
        XCTAssertEqual(project?.name, "Test Test")
        XCTAssertEqual(project?.color, color)
        XCTAssertEqual(project?.identifier, 12)
        XCTAssertEqual(project?.users.count, 1)
        XCTAssertEqual(try (project?.users.first).unwrap(), user)
        XCTAssertEqual(project?.leader, leader)
    }
    
    func testItemAtIndexAfterViewDidLoadRetrunsProjectForSecondRow() throws {
        //Arrange
        let color = UIColor(string: "0c0c0c")
        let firstUser = Project.User(name: "User User")
        let lastUser = Project.User(name: "Admin Admin")
        let leader = Project.User(name: "Rosalind Auer")
        let data = try self.json(from: ProjectsRecordsResponse.projectsRecordsResponse)
        let records = try decoder.decode([ProjectRecordDecoder].self, from: data)
        viewModel.viewDidLoad()
        apiClientMock.fetchAllProjectsCompletion?(.success(records))
        let indexPath = IndexPath(row: 1, section: 0)
        //Act
        let project = viewModel.item(at: indexPath)
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
        //Act
        viewModel.viewDidLoad()
        //Assert
        XCTAssertTrue(userInterfaceMock.setUpViewCalled)
    }
    
    func testViewDidLoadFetchProjectsFailure() throws {
        //Arrange
        let error = TestError(message: "fetch project failure")
        //Act
        viewModel.viewDidLoad()
        apiClientMock.fetchAllProjectsCompletion?(.failure(error))
        //Assert
        XCTAssertEqual(try (errorHandlerMock.throwedError as? TestError).unwrap(), error)
    }
    
}
