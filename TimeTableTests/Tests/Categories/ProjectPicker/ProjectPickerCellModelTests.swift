//
//  ProjectPickerCellModelTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 07/11/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectPickerCellModelTests: XCTestCase {
    private var userInterfaceMock: ProjectPickerCellMock!
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProjectPickerCellMock()
    }
    
    func testViewDidConfigureSetsUpView() {
        //Arrange
        let project = self.buildProjectDecoder()
        let viewModel = self.buildViewModel(project: project)
        //Act
        viewModel.viewDidConfigure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpCalledCount, 1)
        XCTAssertEqual(self.userInterfaceMock.setUpTitle, project.name)
    }
    
    // MARK: - Private
    private func buildViewModel(project: ProjectDecoder) -> ProjectPickerCellModel {
        return ProjectPickerCellModel(
            userInterface: self.userInterfaceMock,
            project: project)
    }
    
    private func buildProjectDecoder() -> ProjectDecoder {
        return ProjectDecoder(
            identifier: 1,
            name: "name",
            color: nil,
            autofill: nil,
            countDuration: nil,
            isActive: nil,
            isInternal: nil,
            isLunch: false,
            workTimesAllowsTask: true)
    }
}
