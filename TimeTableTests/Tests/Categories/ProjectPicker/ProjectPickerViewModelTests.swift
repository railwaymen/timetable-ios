//
//  ProjectPickerViewModelTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectPickerViewModelTests: XCTestCase {
    private let projectDecoderFactory = SimpleProjectRecordDecoderFactory()
    
    private var userInterfaceMock: ProjectPickerViewControllerMock!
    private var coordinatorMock: ProjectPickerCoordinatorMock!
    private var dependencyContainerMock: DependencyContainerMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProjectPickerViewControllerMock()
        self.coordinatorMock = ProjectPickerCoordinatorMock()
        self.dependencyContainerMock = DependencyContainerMock()
    }
}

// MARK: - loadView()
extension ProjectPickerViewModelTests {
    func testLoadViewSetsUpView() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loadView()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 1)
    }
}

// MARK: - numberOfRows(in section: Int) -> Int
extension ProjectPickerViewModelTests {
    func testNumberOfRowsInZeroSection() throws {
        //Arrange
        let projects = [try self.projectDecoderFactory.build()]
        let sut = self.buildSUT(projects: projects)
        //Act
        let numberOfRows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testNumberOfRowsInNotExistingSection() throws {
        //Arrange
        let projects = [try self.projectDecoderFactory.build()]
        let sut = self.buildSUT(projects: projects)
        //Act
        let numberOfRows = sut.numberOfRows(in: 92)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRowsInZeroSectionWithoutProjects() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let numberOfRows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRowsInNotExistingSectionWithoutProjects() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let numberOfRows = sut.numberOfRows(in: 92)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
}

// MARK: - configure(cell: ProjectPickerCellable, for indexPath: IndexPath)
extension ProjectPickerViewModelTests {
    func testConfigureCellConfiguresCell() throws {
        //Arrange
        let cellMock = ProjectPickerCellMock()
        let projects = [try self.projectDecoderFactory.build()]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.configure(cell: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureParams.count, 1)
    }
    
    func testConfigureCellWithoutProjects() {
        //Arrange
        let cellMock = ProjectPickerCellMock()
        let sut = self.buildSUT()
        //Act
        sut.configure(cell: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureParams.count, 0)
    }
}

// MARK: - updateSearchResults(for text: String)
extension ProjectPickerViewModelTests {
    func testUpdateSearchResultsReloadsData() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadDataParams.count, 1)
    }
    
    func testUpdateSearchResultsForEmptyTextDoesNotFilterProjects() throws {
        //Arrange
        let projects = [
            try self.projectDecoderFactory.build(wrapper: .init(id: 1, name: "1")),
            try self.projectDecoderFactory.build(wrapper: .init(id: 2, name: "3"))
        ]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(sut.numberOfRows(in: 0), 2)
    }
    
    func testUpdateSearchResultsForTextFiltersProjectsByName() throws {
        //Arrange
        let projects = [
            try self.projectDecoderFactory.build(wrapper: .init(id: 1, name: "1")),
            try self.projectDecoderFactory.build(wrapper: .init(id: 2, name: "3"))
        ]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.updateSearchResults(for: "3")
        //Assert
        XCTAssertEqual(sut.numberOfRows(in: 0), 1)
    }
}

// MARK: - cellDidSelect(at indexPath: IndexPath)
extension ProjectPickerViewModelTests {
    func testCellDidSelectWithoutProjectsCallsFinishWithoutProject() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.count, 1)
        XCTAssertNil(self.coordinatorMock?.finishFlowParams.last?.project)
    }
    
    func testCellDidSelectExistingProjectCallsFinishWithProperProject() throws {
        //Arrange
        let projects = [
            try self.projectDecoderFactory.build(wrapper: .init(id: 1, name: "1")),
            try self.projectDecoderFactory.build(wrapper: .init(id: 2, name: "3"))
        ]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.last?.project, projects[0])
    }
    
    func testCellDidSelectInporperIndexPathCallsFinishWithoutProject() throws {
        //Arrange
        let projects = [
            try self.projectDecoderFactory.build(wrapper: .init(id: 1, name: "1")),
            try self.projectDecoderFactory.build(wrapper: .init(id: 2, name: "3"))
        ]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.cellDidSelect(at: IndexPath(row: 0, section: 1))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.count, 1)
        XCTAssertNil(self.coordinatorMock.finishFlowParams.last?.project)
    }
}

// MARK: - closeButtonTapped()
extension ProjectPickerViewModelTests {
    func testCloseButtonTappedFinishesFlow() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.closeButtonTapped()
        //Assert
        XCTAssertEqual(self.coordinatorMock?.finishFlowParams.count, 1)
        XCTAssertNil(self.coordinatorMock?.finishFlowParams.last?.project)
    }
}

// MARK: - Private
extension ProjectPickerViewModelTests {
    private func buildSUT(projects: [SimpleProjectRecordDecoder] = []) -> ProjectPickerViewModel {
        return ProjectPickerViewModel(
            userInterface: self.userInterfaceMock,
            coordinator: self.coordinatorMock,
            notificationCenter: self.dependencyContainerMock.notificationCenter,
            projects: projects)
    }
}
