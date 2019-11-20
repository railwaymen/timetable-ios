//
//  WorkTimeCellViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 12/12/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeCellViewModelTests: XCTestCase {
    private var userInterface: WorkTimeCellViewMock!
    private var parent: WorkTimeCellViewModelParentMock!
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    override func setUp() {
        super.setUp()
        self.userInterface = WorkTimeCellViewMock()
        self.parent = WorkTimeCellViewModelParentMock()
    }
    
    func testViewConfiguredCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[0]
        let sut = self.buildSUT(workTime: workTime)
        //Act
        sut.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.durationText, "1h")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.bodyText, "Bracket - v2")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.taskUrlText, "task1")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.fromToDateText, "3:00 PM - 4:00 PM")
    }
    
    func testPrepareForReuseCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[1]
        let sut = self.buildSUT(workTime: workTime)
        //Act
        sut.prepareForReuse()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.durationText, "2h")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.bodyText, "Bracket - v3")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.taskUrlText, "task2")
        XCTAssertEqual(self.userInterface.updateViewParams.last?.data.fromToDateText, "12:00 PM - 2:00 PM")
    }
    
    func testTaskButtonTappedWithValidURLCallsParentOpenTask() throws {
        //Arrange
        let data = try self.json(from: WorkTimesJSONResource.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[1]
        let sut = self.buildSUT(workTime: workTime)
        //Act
        sut.taskButtonTapped()
        //Assert
        XCTAssertEqual(self.parent.openTaskParams.count, 1)
        XCTAssertEqual(self.parent.openTaskParams.last?.workTime, workTime)
    }
}

// MARK: - Private
extension WorkTimeCellViewModelTests {
    private func buildSUT(workTime: WorkTimeDecoder) -> WorkTimeCellViewModel {
        return WorkTimeCellViewModel(workTime: workTime,
                                     userInterface: self.userInterface,
                                     parent: self.parent)
    }
}
