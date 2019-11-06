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
        parent = WorkTimeCellViewModelParentMock()
        userInterface = WorkTimeCellViewMock()
        super.setUp()
    }
    
    func testViewConfiguredCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[0]
        let viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: userInterface, parent: parent)
        //Act
        viewModel.viewConfigured()
        //Assert
        XCTAssertEqual(userInterface.updateViewData?.durationText, "1h")
        XCTAssertEqual(userInterface.updateViewData?.bodyText, "Bracket - v2")
        XCTAssertEqual(userInterface.updateViewData?.taskUrlText, "task1")
        XCTAssertEqual(userInterface.updateViewData?.fromToDateText, "3:00 PM - 4:00 PM")
    }
    
    func testPrepareForReuseCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[1]
        let viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: userInterface, parent: parent)
        //Act
        viewModel.prepareForReuse()
        //Assert
        XCTAssertEqual(userInterface.updateViewData?.durationText, "2h")
        XCTAssertEqual(userInterface.updateViewData?.bodyText, "Bracket - v3")
        XCTAssertEqual(userInterface.updateViewData?.taskUrlText, "task2")
        XCTAssertEqual(userInterface.updateViewData?.fromToDateText, "12:00 PM - 2:00 PM")
    }
    
    func testTaskButtonTappedWithValidURLCallsParentOpenTask() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[1]
        let viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: userInterface, parent: parent)
        //Act
        viewModel.taskButtonTapped()
        //Assert
        XCTAssertEqual(parent.openTaskCalledCount, 1)
        XCTAssertEqual(parent.openTaskWorkTime, workTime)
    }
}

private class WorkTimeCellViewMock: WorkTimeCellViewModelOutput {
    private(set) var setUpCalled = false
    func setUp() {
        self.setUpCalled = true
    }
    
    private(set) var updateViewData: WorkTimeCellViewModel.ViewData?
    func updateView(data: WorkTimeCellViewModel.ViewData) {
        updateViewData = data
    }
}

private class WorkTimeCellViewModelParentMock: WorkTimeCellViewModelParentType {
    private(set) var openTaskCalledCount = 0
    private(set) var openTaskWorkTime: WorkTimeDecoder?
    func openTask(for workTime: WorkTimeDecoder) {
        openTaskCalledCount += 1
        openTaskWorkTime = workTime
    }
}
