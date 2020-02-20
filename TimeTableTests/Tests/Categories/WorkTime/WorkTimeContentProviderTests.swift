//
//  WorkTimeContentProviderTests.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 19/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
@testable import TimeTable

class WorkTimeContentProviderTests: XCTestCase {
    private let projectFactory = ProjectDecoderFactory()
    private let simpleProjectDecoderFactory = SimpleProjectDecoderFactory()
    private let taskFactory = TaskFactory()
    
    private var apiClient: ApiClientMock!
    private var calendar: CalendarMock!
    
    override func setUp() {
        super.setUp()
        self.apiClient = ApiClientMock()
        self.calendar = CalendarMock()
    }
}

// MARK: - fetchSimpleProjectsList(completion:)
extension WorkTimeContentProviderTests {
    func testFetchSimpleProjectsList_resultSuccess() throws {
        //Arrange
        let sut = self.buildSUT()
        let projectWithoutIsActive = try self.projectFactory.build(wrapper: .init(isActive: nil))
        let activeProject = try self.projectFactory.build(wrapper: .init(isActive: true))
        let inactiveProject = try self.projectFactory.build(wrapper: .init(isActive: false))
        let projects = [activeProject, inactiveProject, projectWithoutIsActive]
        let tags: [ProjectTag] = [.default, .internalMeeting]
        let simpleProject = try self.simpleProjectDecoderFactory.build(wrapper: .init(projects: projects, tags: tags))
        var completionResult: FetchSimpleProjectsListResult?
        //Act
        sut.fetchSimpleProjectsList { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.fetchSimpleListOfProjectsParams.last).completion(.success(simpleProject))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get().projects, [activeProject])
        XCTAssertEqual(try XCTUnwrap(completionResult).get().tags, [.internalMeeting])
    }
    
    func testFetchSimpleProjectsList_resultFailure() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = ApiClientError(type: .invalidResponse)
        var completionResult: FetchSimpleProjectsListResult?
        //Act
        sut.fetchSimpleProjectsList { result in
            completionResult = result
        }
        try XCTUnwrap(self.apiClient.fetchSimpleListOfProjectsParams.last).completion(.failure(error))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: error)
    }
}

// MARK: - Private
extension WorkTimeContentProviderTests {
    private func buildSUT() -> WorkTimeContentProvider {
        return WorkTimeContentProvider(
            apiClient: self.apiClient,
            calendar: self.calendar)
    }
}
