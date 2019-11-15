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
        let viewModel = self.buildViewModel()
        //Act
        viewModel.loadView()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpCalledCount, 1)
    }
        
    func testNumberOfRowsInZeroSection() {
        //Arrange
        let projects = [self.buildProjectDecoder()]
        let viewModel = self.buildViewModel(projects: projects)
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testNumberOfRowsInNotExistingSection() {
        //Arrange
        let projects = [self.buildProjectDecoder()]
        let viewModel = self.buildViewModel(projects: projects)
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 92)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRowsInZeroSectionWithoutProjects() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRowsInNotExistingSectionWithoutProjects() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 92)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testConfigureCellConfiguresCell() {
        //Arrange
        let cellMock = ProjectPickerCellMock()
        let projects = [self.buildProjectDecoder()]
        let viewModel = self.buildViewModel(projects: projects)
        //Act
        viewModel.configure(cell: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureParams.count, 1)
    }
    
    func testConfigureCellWithoutProjects() {
        //Arrange
        let cellMock = ProjectPickerCellMock()
        let viewModel = self.buildViewModel()
        //Act
        viewModel.configure(cell: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureParams.count, 0)
    }
    
    func testUpdateSearchResultsReloadsData() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        viewModel.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(self.userInterfaceMock.reloadDataCalledCount, 1)
    }
    
    func testUpdateSearchResultsForEmptyTextDoesNotFilterProjects() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let viewModel = self.buildViewModel(projects: projects)
        //Act
        viewModel.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 2)
    }
    
    func testUpdateSearchResultsForTextFiltersProjectsByName() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let viewModel = self.buildViewModel(projects: projects)
        //Act
        viewModel.updateSearchResults(for: "3")
        //Assert
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 1)
    }
    
    func testCellDidSelectWithoutProjectsCallsFinishWithoutProject() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        viewModel.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowCalledCount, 1)
        XCTAssertNil(self.coordinatorMock.finishFlowProject)
    }
    
    func testCellDidSelectExistingProjectCallsFinishWithProperProject() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let viewModel = self.buildViewModel(projects: projects)
        //Act
        viewModel.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowCalledCount, 1)
        XCTAssertEqual(self.coordinatorMock.finishFlowProject, projects[0])
    }
    
    func testCellDidSelectInporperIndexPathCallsFinishWithoutProject() {
        //Arrange
        let projects = [self.buildProjectDecoder(id: 1, name: "1"), self.buildProjectDecoder(id: 2, name: "3")]
        let viewModel = self.buildViewModel(projects: projects)
        //Act
        viewModel.cellDidSelect(at: IndexPath(row: 0, section: 1))
        //Assert
        XCTAssertEqual(self.coordinatorMock.finishFlowCalledCount, 1)
        XCTAssertNil(self.coordinatorMock.finishFlowProject)
    }
    
    func testCloseButtonTappedFinishesFlow() {
        //Arrange
        let viewModel = self.buildViewModel()
        //Act
        viewModel.closeButtonTapped()
        //Assert
        XCTAssertEqual(self.coordinatorMock?.finishFlowCalledCount, 1)
        XCTAssertNil(self.coordinatorMock?.finishFlowProject)
    }
    
    // MARK: - Private
    private func buildViewModel(projects: [ProjectDecoder] = []) -> ProjectPickerViewModel {
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
            workTimesAllowsTask: true)
    }
}
