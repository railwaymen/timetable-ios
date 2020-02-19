//
//  WorkTimeViewModelFlowTypeTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/12/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeViewModelFlowTypeTests: XCTestCase {
    typealias SUT = WorkTimeViewModel.FlowType
}

// MARK: - viewTitle
extension WorkTimeViewModelFlowTypeTests {
    func testViewTitle_newEntry() {
        //Arrange
        let sut: SUT = .newEntry(lastTask: nil)
        //Assert
        XCTAssertEqual(sut.viewTitle, "work_time.title.new".localized)
    }
    
    func testViewTitle_editEntry() {
        //Arrange
        let task = self.buildTask(id: 1)
        let sut: SUT = .editEntry(editedTask: task)
        //Assert
        XCTAssertEqual(sut.viewTitle, "work_time.title.edit".localized)
    }
    
    func testViewTitle_duplicateEntry() {
        //Arrange
        let task = self.buildTask(id: 1)
        let sut: SUT = .duplicateEntry(duplicatedTask: task, lastTask: nil)
        //Assert
        XCTAssertEqual(sut.viewTitle, "work_time.title.new".localized)
    }
}

// MARK: - Equatable
extension WorkTimeViewModelFlowTypeTests {
    func testEquatable_identicalNewEntryWithNil() throws {
        //Arrange
        let sut1: SUT = .newEntry(lastTask: nil)
        let sut2: SUT = .newEntry(lastTask: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_identicalNewEntryWithLastTask() throws {
        //Arrange
        let task = self.buildTask(id: 1)
        let sut1: SUT = .newEntry(lastTask: task)
        let sut2: SUT = .newEntry(lastTask: task)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_newEntryNilAndNewEntryWithLastTask() throws {
        //Arrange
        let task = self.buildTask(id: 1)
        let sut1: SUT = .newEntry(lastTask: nil)
        let sut2: SUT = .newEntry(lastTask: task)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatable_differentNewEntry() throws {
        //Arrange
        let sut1: SUT = .newEntry(lastTask: self.buildTask(id: 1))
        let sut2: SUT = .newEntry(lastTask: self.buildTask(id: 2))
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatable_identicalEditEntryWithTask() throws {
        //Arrange
        let task = self.buildTask(id: 1)
        let sut1: SUT = .editEntry(editedTask: task)
        let sut2: SUT = .editEntry(editedTask: task)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_differentEditEntry() throws {
        //Arrange
        let sut1: SUT = .editEntry(editedTask: self.buildTask(id: 1))
        let sut2: SUT = .editEntry(editedTask: self.buildTask(id: 2))
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatable_identicalDuplicateEntryWithNilLastTask() throws {
        //Arrange
        let task = self.buildTask(id: 1)
        let sut1: SUT = .duplicateEntry(duplicatedTask: task, lastTask: nil)
        let sut2: SUT = .duplicateEntry(duplicatedTask: task, lastTask: nil)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_identicalDuplicateEntryWithLastTask() throws {
        //Arrange
        let task1 = self.buildTask(id: 1)
        let task2 = self.buildTask(id: 2)
        let sut1: SUT = .duplicateEntry(duplicatedTask: task1, lastTask: task2)
        let sut2: SUT = .duplicateEntry(duplicatedTask: task1, lastTask: task2)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_duplicateEntryNilLastTaskAndDuplicateEntryWithLastTask() throws {
        //Arrange
        let task1 = self.buildTask(id: 1)
        let task2 = self.buildTask(id: 2)
        let sut1: SUT = .duplicateEntry(duplicatedTask: task1, lastTask: nil)
        let sut2: SUT = .duplicateEntry(duplicatedTask: task1, lastTask: task2)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatable_differentDuplicateEntryLastTask() throws {
        //Arrange
        let task1 = self.buildTask(id: 1)
        let task2 = self.buildTask(id: 2)
        let task3 = self.buildTask(id: 3)
        let sut1: SUT = .duplicateEntry(duplicatedTask: task1, lastTask: task2)
        let sut2: SUT = .duplicateEntry(duplicatedTask: task1, lastTask: task3)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatable_differentDuplicateEntryDuplicateTask() throws {
        //Arrange
        let task1 = self.buildTask(id: 1)
        let task2 = self.buildTask(id: 2)
        let sut1: SUT = .duplicateEntry(duplicatedTask: task1, lastTask: nil)
        let sut2: SUT = .duplicateEntry(duplicatedTask: task2, lastTask: nil)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatable_newEntryAndEditEntry() throws {
        //Arrange
        let task = self.buildTask(id: 1)
        let sut1: SUT = .newEntry(lastTask: task)
        let sut2: SUT = .editEntry(editedTask: task)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
}

// MARK: - Private
extension WorkTimeViewModelFlowTypeTests {
    private func buildTask(id: Int64) -> TaskForm {
        return TaskForm(
            workTimeIdentifier: id,
            body: "body")
    }
}
