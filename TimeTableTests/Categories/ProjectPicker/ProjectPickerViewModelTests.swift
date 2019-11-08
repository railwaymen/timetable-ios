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
        userInterfaceMock = ProjectPickerViewControllerMock()
        coordinatorMock = ProjectPickerCoordinatorMock()
        dependencyContainerMock = DependencyContainerMock()
    }
    
    func testLoadViewSetsUpView() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        viewModel.loadView()
        //Assert
        XCTAssertEqual(userInterfaceMock.setUpCalledCount, 1)
    }
        
    func testNumberOfRowsInZeroSection() {
        //Arrange
        let projects = [buildProjectDecoder()]
        let viewModel = buildViewModel(projects: projects)
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func testNumberOfRowsInNotExistingSection() {
        //Arrange
        let projects = [buildProjectDecoder()]
        let viewModel = buildViewModel(projects: projects)
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 92)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRowsInZeroSectionWithoutProjects() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 0)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRowsInNotExistingSectionWithoutProjects() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        let numberOfRows = viewModel.numberOfRows(in: 92)
        //Assert
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testConfigureCellConfiguresCell() {
        //Arrange
        let cellMock = ProjectPickerCellMock()
        let projects = [buildProjectDecoder()]
        let viewModel = buildViewModel(projects: projects)
        //Act
        viewModel.configure(cell: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureCalledCount, 1)
    }
    
    func testConfigureCellWithoutProjects() {
        //Arrange
        let cellMock = ProjectPickerCellMock()
        let viewModel = buildViewModel()
        //Act
        viewModel.configure(cell: cellMock, for: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(cellMock.configureCalledCount, 0)
    }
    
    func testUpdateSearchResultsReloadsData() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        viewModel.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(userInterfaceMock.reloadDataCalledCount, 1)
    }
    
    func testUpdateSearchResultsForEmptyTextDoesNotFilterProjects() {
        //Arrange
        let projects = [buildProjectDecoder(id: 1, name: "1"), buildProjectDecoder(id: 2, name: "3")]
        let viewModel = buildViewModel(projects: projects)
        //Act
        viewModel.updateSearchResults(for: "")
        //Assert
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 2)
    }
    
    func testUpdateSearchResultsForTextFiltersProjectsByName() {
        //Arrange
        let projects = [buildProjectDecoder(id: 1, name: "1"), buildProjectDecoder(id: 2, name: "3")]
        let viewModel = buildViewModel(projects: projects)
        //Act
        viewModel.updateSearchResults(for: "3")
        //Assert
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 1)
    }
    
    func testCellDidSelectWithoutProjectsCallsFinishWithoutProject() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        viewModel.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(coordinatorMock.finishFlowCalledCount, 1)
        XCTAssertNil(coordinatorMock.finishFlowProject)
    }
    
    func testCellDidSelectExistingProjectCallsFinishWithProperProject() {
        //Arrange
        let projects = [buildProjectDecoder(id: 1, name: "1"), buildProjectDecoder(id: 2, name: "3")]
        let viewModel = buildViewModel(projects: projects)
        //Act
        viewModel.cellDidSelect(at: IndexPath(row: 0, section: 0))
        //Assert
        XCTAssertEqual(coordinatorMock.finishFlowCalledCount, 1)
        XCTAssertEqual(coordinatorMock.finishFlowProject, projects[0])
    }
    
    func testCellDidSelectInporperIndexPathCallsFinishWithoutProject() {
        //Arrange
        let projects = [buildProjectDecoder(id: 1, name: "1"), buildProjectDecoder(id: 2, name: "3")]
        let viewModel = buildViewModel(projects: projects)
        //Act
        viewModel.cellDidSelect(at: IndexPath(row: 0, section: 1))
        //Assert
        XCTAssertEqual(coordinatorMock.finishFlowCalledCount, 1)
        XCTAssertNil(coordinatorMock.finishFlowProject)
    }
    
    func testCloseButtonTappedFinishesFlow() {
        //Arrange
        let viewModel = buildViewModel()
        //Act
        viewModel.closeButtonTapped()
        //Assert
        XCTAssertEqual(coordinatorMock?.finishFlowCalledCount, 1)
        XCTAssertNil(coordinatorMock?.finishFlowProject)
    }
    
    // MARK: - Private
    private func buildViewModel(projects: [ProjectDecoder] = []) -> ProjectPickerViewModel {
        return ProjectPickerViewModel(
            userInterface: userInterfaceMock,
            coordinator: coordinatorMock,
            notificationCenter: dependencyContainerMock.notificationCenter,
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
