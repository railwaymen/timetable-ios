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
    private var userInterfaceMock: ProjectPickerViewControllerMock!
    private var coordinatorMock: ProjectPickerCoordinatorMock!
    private var dependencyContainerMock: DependencyContainerMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProjectPickerViewControllerMock()
        self.coordinatorMock = ProjectPickerCoordinatorMock()
        self.dependencyContainerMock = DependencyContainerMock()
    }
    
    func testLoadViewSetsUpView() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.loadView()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 1)
    }
        
    func testNumberOfRowsInZeroSection() {
        //Arrange
        let projects = [self.buildProjectDecoder()]
        let sut = self.buildSUT(projects: projects)
        //Act
        let numberOfRows = sut.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testNumberOfRowsInNotExistingSection() {
        //Arrange
        let projects = [self.buildProjectDecoder()]
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
    
    func testConfigureCellConfiguresCell() {
        //Arrange
        let cellMock = ProjectPickerCellMock()
        let projects = [self.buildProjectDecoder()]
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
    
    func testUpdateSearchResultsReloadsData() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadDataParams.count, 1)
    }
    
    func testUpdateSearchResultsForEmptyTextDoesNotFilterProjects() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(sut.numberOfRows(in: 0), 2)
    }
    
    func testUpdateSearchResultsForTextFiltersProjectsByName() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.updateSearchResults(for: "3")
        //Assert
        XCTAssertEqual(sut.numberOfRows(in: 0), 1)
    }
    
    func testCellDidSelectWithoutProjectsCallsFinishWithoutProject() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.count, 1)
        XCTAssertNil(self.coordinatorMock?.finishFlowParams.last?.project)
    }
    
    func testCellDidSelectExistingProjectCallsFinishWithProperProject() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.count, 1)
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.last?.project, projects[0])
    }
    
    func testCellDidSelectInporperIndexPathCallsFinishWithoutProject() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let sut = self.buildSUT(projects: projects)
        //Act
        sut.cellDidSelect(at: IndexPath(row: 0, section: 1))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowParams.count, 1)
        XCTAssertNil(self.coordinatorMock.finishFlowParams.last?.project)
    }
    
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
    private func buildSUT(projects: [ProjectDecoder] = []) -> ProjectPickerViewModel {
        return ProjectPickerViewModel(
            userInterface: self.userInterfaceMock,
            coordinator: self.coordinatorMock,
            notificationCenter: self.dependencyContainerMock.notificationCenter,
            projects: projects)
    }
    
    private func buildProjectDecoder(id: Int = 1, name: String = "name") -> ProjectDecoder {
        return ProjectDecoder(
            identifier: id,
            name: name,
            color: nil,
            autofill: nil,
            countDuration: nil,
            isActive: nil,
            isInternal: nil,
            isLunch: false,
            workTimesAllowsTask: true,
            isTaggable: true)
    }
}
