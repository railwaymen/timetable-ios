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
    private var viewModel: WorkTimeCellViewModel!
    
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
        userInterface = WorkTimeCellViewMock()
        super.setUp()
    }
    
    func testViewConfiguredCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[0]
        viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: userInterface)
        //Act
        viewModel.viewConfigured()
        //Assert
        XCTAssertEqual(userInterface.updateViewData?.durationText, "1:00")
        XCTAssertEqual(userInterface.updateViewData?.bodyText, "Bracket - v2")
        XCTAssertEqual(userInterface.updateViewData?.taskUrlText, "task1")
        XCTAssertEqual(userInterface.updateViewData?.fromToDateText, "3:00 PM - 4:00 PM")
    }
    
    func testPrepareForReuseCallsUpdateView() throws {
        //Arrange
        let data = try self.json(from: WorkTimesResponse.workTimesResponse)
        let workTimes = try self.decoder.decode([WorkTimeDecoder].self, from: data)
        let workTime = workTimes[1]
        viewModel = WorkTimeCellViewModel(workTime: workTime, userInterface: userInterface)
        //Act
        viewModel.prepareForReuse()
        //Assert
        XCTAssertEqual(userInterface.updateViewData?.durationText, "2:00")
        XCTAssertEqual(userInterface.updateViewData?.bodyText, "Bracket - v3")
        XCTAssertEqual(userInterface.updateViewData?.taskUrlText, "task2")
        XCTAssertEqual(userInterface.updateViewData?.fromToDateText, "12:00 PM - 2:00 PM")
    }
}

private class WorkTimeCellViewMock: WorkTimeCellViewModelOutput {
    private(set) var updateViewData: WorkTimeCellViewModel.ViewData?
    func updateView(data: WorkTimeCellViewModel.ViewData) {
        updateViewData = data
    }
}
