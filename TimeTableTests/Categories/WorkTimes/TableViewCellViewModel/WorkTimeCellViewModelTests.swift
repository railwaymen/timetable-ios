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
    
    private enum WorkTimesResponse: String, JSONFileResource {
        case workTimesResponse
        case workTimesResponseNotSorted
    }
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    override func setUp() {
        super.setUp()
        self.parent = WorkTimeCellViewModelParentMock()
        self.userInterface = WorkTimeCellViewMock()
    }
    
    func testViewConfiguredCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[0]
        let viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: self.userInterface, parent: self.parent)
        //Act
        viewModel.viewConfigured()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewData?.durationText, "1h")
        XCTAssertEqual(self.userInterface.updateViewData?.bodyText, "Bracket - v2")
        XCTAssertEqual(self.userInterface.updateViewData?.taskUrlText, "task1")
        XCTAssertEqual(self.userInterface.updateViewData?.fromToDateText, "3:00 PM - 4:00 PM")
    }
    
    func testPrepareForReuseCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[1]
        let viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: self.userInterface, parent: self.parent)
        //Act
        viewModel.prepareForReuse()
        //Assert
        XCTAssertEqual(self.userInterface.updateViewData?.durationText, "2h")
        XCTAssertEqual(self.userInterface.updateViewData?.bodyText, "Bracket - v3")
        XCTAssertEqual(self.userInterface.updateViewData?.taskUrlText, "task2")
        XCTAssertEqual(self.userInterface.updateViewData?.fromToDateText, "12:00 PM - 2:00 PM")
    }
    
    func testTaskButtonTappedWithValidURLCallsParentOpenTask() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[1]
        let viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: self.userInterface, parent: self.parent)
        //Act
        viewModel.taskButtonTapped()
        //Assert
        XCTAssertEqual(self.parent.openTaskCalledCount, 1)
        XCTAssertEqual(self.parent.openTaskWorkTime, workTime)
    }
}
