//
//  ProjectsViewModelTests.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class ProjectsViewModelTests: XCTestCase {
    private var userInterfaceMock: ProjectsViewControllerMock!
    private var apiClientMock: ApiClientMock!
    private var errorHandlerMock: ErrorHandlerMock!
    private var notificationCenterMock: NotificationCenterMock!
    private let projectRecordDecoderFactory = ProjectRecordDecoderFactory()
    
    override func setUp() {
        super.setUp()
        self.userInterfaceMock = ProjectsViewControllerMock()
        self.apiClientMock = ApiClientMock()
        self.errorHandlerMock = ErrorHandlerMock()
        self.notificationCenterMock = NotificationCenterMock()
    }
}

// MARK: - Default init
extension ProjectsViewModelTests {
    func testInit_setsUpNotifications() {
        //Act
        _ = self.buildSUT()
        //Assert
        XCTAssertEqual(self.notificationCenterMock.addObserverParams.count, 1)
        XCTAssertEqual(self.notificationCenterMock.addObserverParams.first?.name, UIDevice.orientationDidChangeNotification)
    }
}

// MARK: - screenOrientationDidChange()
extension ProjectsViewModelTests {
    func testScreenOrientationDidChange() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.screenOrientationDidChange()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.screenOrientationDidChangeParams.count, 1)
    }
}

// MARK: - viewDidLoad()
extension ProjectsViewModelTests {
    func testViewDidLoad_setsUpView() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        //Assert
        XCTAssertEqual(self.userInterfaceMock.setUpViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 1)
        XCTAssertFalse(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
    }
    
    func testViewDidLoad_fetchProjects_testError() throws {
        //Arrange
        let error = TestError(message: "fetch project failure")
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(try XCTUnwrap(self.errorHandlerMock.throwingParams.last?.error as? TestError), error)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
    
    func testViewDidLoad_fetchProjects_timeout() throws {
        //Arrange
        let error = ApiClientError(type: .timeout)
        let sut = self.buildSUT()
        //Act
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.failure(error))
        //Assert
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 0)
        XCTAssertEqual(self.userInterfaceMock.setActivityIndicatorParams.count, 2)
        XCTAssertTrue(try XCTUnwrap(self.userInterfaceMock.setActivityIndicatorParams.last?.isHidden))
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
}

// MARK: - numberOfItems()
extension ProjectsViewModelTests {
    func testNumberOfItems_withoutProjects() {
        //Arrange
        let sut = self.buildSUT()
        //Act
        let numberOfItems = sut.numberOfItems()
        //Assert
        XCTAssertEqual(numberOfItems, 0)
    }
    
    func testNuberOfItems_withProjects() throws {
        //Arrange
        let projects = try self.buildProjects()
        let sut = self.buildSUT()
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.success(projects))
        //Act
        let numberOfItems = sut.numberOfItems()
        //Assert
        XCTAssertEqual(numberOfItems, 3)
    }
}

// MARK: - item(at:)
extension ProjectsViewModelTests {
    func testItemAtIndex_withoutProjects() {
        //Arrange
        let sut = self.buildSUT()
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        let project = sut.item(at: indexPath)
        //Assert
        XCTAssertNil(project)
    }
    
    func testItemAtIndex_withProjects_firstRow() throws {
        //Arrange
        let projects = try self.buildProjects()
        let sut = self.buildSUT()
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.success(projects))
        let indexPath = IndexPath(row: 0, section: 0)
        //Act
        let project = sut.item(at: indexPath)
        //Assert
        XCTAssertNotNil(project)
    }
    
    func testItemAtIndex_withProjects_secondRow() throws {
        //Arrange
        let projects = try self.buildProjects()
        let sut = self.buildSUT()
        sut.viewDidLoad()
        self.apiClientMock.fetchAllProjectsParams.last?.completion(.success(projects))
        let indexPath = IndexPath(row: 1, section: 0)
        //Act
        let project = sut.item(at: indexPath)
        //Assert
        XCTAssertNotNil(project)
    }
}

// MARK: - refreshData(completion:)
extension ProjectsViewModelTests {
    func testRefreshData_callsFetch() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionCalledCount = 0
        //Act
        sut.refreshData { completionCalledCount += 1 }
        //Assert
        XCTAssertEqual(self.apiClientMock.fetchAllProjectsParams.count, 1)
        XCTAssertEqual(completionCalledCount, 0)
    }
    
    func testRefreshData_fetchSuccess() throws {
        //Arrange
        let projects = try self.buildProjects()
        let sut = self.buildSUT()
        var completionCalledCount = 0
        //Act
        sut.refreshData { completionCalledCount += 1 }
        try XCTUnwrap(self.apiClientMock.fetchAllProjectsParams.first).completion(.success(projects))
        //Assert
        XCTAssertEqual(self.apiClientMock.fetchAllProjectsParams.count, 1)
        XCTAssertEqual(completionCalledCount, 1)
        XCTAssertEqual(self.userInterfaceMock.updateViewParams.count, 1)
        XCTAssertEqual(self.userInterfaceMock.showCollectionViewParams.count, 1)
        XCTAssertEqual(sut.numberOfItems(), 3)
    }
    
    func testRefreshData_fetchFailed_timeout() throws {
        //Arrange
        let error = ApiClientError(type: .timeout)
        let sut = self.buildSUT()
        var completionCalledCount = 0
        //Act
        sut.refreshData { completionCalledCount += 1 }
        try XCTUnwrap(self.apiClientMock.fetchAllProjectsParams.first).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.apiClientMock.fetchAllProjectsParams.count, 1)
        XCTAssertEqual(completionCalledCount, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 0)
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
    
    func testRefreshData_fetchFailed_differentError() throws {
        //Arrange
        let error = TestError(message: "Test error")
        let sut = self.buildSUT()
        var completionCalledCount = 0
        //Act
        sut.refreshData { completionCalledCount += 1 }
        try XCTUnwrap(self.apiClientMock.fetchAllProjectsParams.first).completion(.failure(error))
        //Assert
        XCTAssertEqual(self.apiClientMock.fetchAllProjectsParams.count, 1)
        XCTAssertEqual(completionCalledCount, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.count, 1)
        XCTAssertEqual(self.errorHandlerMock.throwingParams.first?.error as? TestError, error)
        XCTAssertEqual(self.userInterfaceMock.showErrorViewParams.count, 1)
    }
}

// MARK: - Private
extension ProjectsViewModelTests {
    private func buildSUT() -> ProjectsViewModel {
        return ProjectsViewModel(
            userInterface: self.userInterfaceMock,
            apiClient: self.apiClientMock,
            errorHandler: self.errorHandlerMock,
            notificationCenter: self.notificationCenterMock)
    }
    
    private func buildProjects() throws -> [ProjectRecordDecoder] {
        return [
            try projectRecordDecoderFactory.build(identifier: 1),
            try projectRecordDecoderFactory.build(identifier: 2),
            try projectRecordDecoderFactory.build(identifier: 3)
        ]
    }
}
