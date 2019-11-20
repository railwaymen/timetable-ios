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
        let sut = self.buildSUT(project: project)
        //Act
        sut.viewDidConfigure()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setUpParams.last?.title, project.name)
    }
}

// MARK: - Private
extension ProjectPickerCellModelTests {
    private func buildSUT(project: ProjectDecoder) -> ProjectPickerCellModel {
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
