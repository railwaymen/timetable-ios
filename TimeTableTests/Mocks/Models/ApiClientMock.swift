//
//  ApiClientMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
import Restler
@testable import TimeTable

class ApiClientMock {
    // MARK: - ApiClientNetworkingType
    private(set) var setAuthenticationTokenParams: [SetAuthenticationTokenParams] = []
    struct SetAuthenticationTokenParams {
        let token: String
    }
    
    private(set) var removeAuthenticationTokenParams: [RemoveAuthenticationTokenParams] = []
    struct RemoveAuthenticationTokenParams {}

    // MARK: - ApiClientSessionType
    private(set) var signInParams: [SignInParams] = []
    struct SignInParams {
        let credentials: LoginCredentials
        let completion: ((Result<SessionDecoder, Error>) -> Void)
    }
    
    // MARK: - ApiClientWorkTimesType
    var fetchWorkTimesReturnValue: RestlerTaskType?
    private(set) var fetchWorkTimesParams: [FetchWorkTimesParams] = []
    struct FetchWorkTimesParams {
        let parameters: WorkTimesParameters
        let completion: ((Result<[WorkTimeDecoder], Error>) -> Void)
    }
    
    var fetchWorkTimeDetailsReturnValue: RestlerTaskType?
    private(set) var fetchWorkTimeDetailsParams: [FetchWorkTimeDetailsParams] = []
    struct FetchWorkTimeDetailsParams {
        let identifier: Int64
        let completion: (Result<WorkTimeDecoder, Error>) -> Void
    }
    
    private(set) var addWorkTimeParams: [AddWorkTimeParams] = []
    struct AddWorkTimeParams {
        let parameters: Task
        let completion: ((Result<Void, Error>) -> Void)
    }
    
    private(set) var addWorkTimeWithFillingParams: [AddWorkTimeWithFillingParams] = []
    struct AddWorkTimeWithFillingParams {
        let task: Task
        let completion: ((Result<Void, Error>) -> Void)
    }
    
    private(set) var deleteWorkTimeParams: [DeleteWorkTimeParams] = []
    struct DeleteWorkTimeParams {
        let identifier: Int64
        let completion: ((Result<Void, Error>) -> Void)
    }
    
    private(set) var updateWorkTimeParams: [UpdateWorkTimeParams] = []
    struct UpdateWorkTimeParams {
        let identifier: Int64
        let parameters: Task
        let completion: ((Result<Void, Error>) -> Void)
    }
    
    // MARK: - ApiClientProjectsType
    private(set) var fetchAllProjectsParams: [FetchAllProjectsParams] = []
    struct FetchAllProjectsParams {
        let completion: ((Result<[ProjectRecordDecoder], Error>) -> Void)
    }
    
    var fetchSimpleListOfProjectsReturnValue: RestlerTaskType?
    private(set) var fetchSimpleListOfProjectsParams: [FetchSimpleListOfProjectsParams] = []
    struct FetchSimpleListOfProjectsParams {
        let completion: ((Result<[SimpleProjectRecordDecoder], Error>) -> Void)
    }
    
    var fetchTagsReturnValue: RestlerTaskType?
    private(set) var fetchTagsParams: [FetchTagsParams] = []
    struct FetchTagsParams {
        let completion: ((Result<ProjectTagsDecoder, Error>) -> Void)
    }
    
    // MARK: - ApiClientUsersType
    private(set) var fetchUserProfileParams: [FetchUserProfileParams] = []
    struct FetchUserProfileParams {
        let identifier: Int64
        let completion: ((Result<UserDecoder, Error>) -> Void)
    }
    
    // MARK: - ApiClientMatchingFullTimeType
    private(set) var fetchMatchingFullTimeParams: [FetchMatchingFullTimeParams] = []
    struct FetchMatchingFullTimeParams {
        let parameters: MatchingFullTimeEncoder
        let completion: ((Result<MatchingFullTimeDecoder, Error>) -> Void)
    }
}

// MARK: - ApiClientNetworkingType
extension ApiClientMock: ApiClientNetworkingType {
    func setAuthenticationToken(_ token: String) {
        self.setAuthenticationTokenParams.append(SetAuthenticationTokenParams(token: token))
    }
    
    func removeAuthenticationToken() {
        self.removeAuthenticationTokenParams.append(RemoveAuthenticationTokenParams())
    }
}

// MARK: - ApiClientSessionType
extension ApiClientMock: ApiClientSessionType {
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder, Error>) -> Void)) {
        self.signInParams.append(SignInParams(credentials: credentials, completion: completion))
    }
}

// MARK: - ApiClientWorkTimesType
extension ApiClientMock: ApiClientWorkTimesType {
    func fetchWorkTimes(
        parameters: WorkTimesParameters,
        completion: @escaping ((Result<[WorkTimeDecoder], Error>) -> Void)
    ) -> RestlerTaskType? {
        self.fetchWorkTimesParams.append(FetchWorkTimesParams(parameters: parameters, completion: completion))
        return self.fetchWorkTimesReturnValue
    }
    
    func fetchWorkTimeDetails(
        identifier: Int64,
        completion: @escaping (Result<WorkTimeDecoder, Error>) -> Void
    ) -> RestlerTaskType? {
        self.fetchWorkTimeDetailsParams.append(FetchWorkTimeDetailsParams(identifier: identifier, completion: completion))
        return self.fetchWorkTimeDetailsReturnValue
    }
    
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.addWorkTimeParams.append(AddWorkTimeParams(parameters: parameters, completion: completion))
    }
    
    func addWorkTimeWithFilling(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        self.addWorkTimeWithFillingParams.append(AddWorkTimeWithFillingParams(task: task, completion: completion))
    }
    
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.deleteWorkTimeParams.append(DeleteWorkTimeParams(identifier: identifier, completion: completion))
    }
    
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.updateWorkTimeParams.append(UpdateWorkTimeParams(
            identifier: identifier,
            parameters: parameters,
            completion: completion))
    }
}

// MARK: - ApiClientProjectsType
extension ApiClientMock: ApiClientProjectsType {
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder], Error>) -> Void)) {
        self.fetchAllProjectsParams.append(FetchAllProjectsParams(completion: completion))
    }
    
    func fetchSimpleListOfProjects(
        completion: @escaping ((Result<[SimpleProjectRecordDecoder], Error>) -> Void)
    ) -> RestlerTaskType? {
        self.fetchSimpleListOfProjectsParams.append(FetchSimpleListOfProjectsParams(completion: completion))
        return self.fetchSimpleListOfProjectsReturnValue
    }
    
    func fetchTags(completion: @escaping (Result<ProjectTagsDecoder, Error>) -> Void) -> RestlerTaskType? {
        self.fetchTagsParams.append(FetchTagsParams(completion: completion))
        return self.fetchTagsReturnValue
    }
}

// MARK: - ApiClientUsersType
extension ApiClientMock: ApiClientUsersType {
    func fetchUserProfile(forIdetifier identifier: Int64, completion: @escaping ((Result<UserDecoder, Error>) -> Void)) {
        self.fetchUserProfileParams.append(FetchUserProfileParams(identifier: identifier, completion: completion))
    }
}

// MARK: - ApiClientMatchingFullTimeType
extension ApiClientMock: ApiClientMatchingFullTimeType {
    func fetchMatchingFullTime(
        parameters: MatchingFullTimeEncoder,
        completion: @escaping ((Result<MatchingFullTimeDecoder, Error>) -> Void)
    ) {
        self.fetchMatchingFullTimeParams.append(FetchMatchingFullTimeParams(parameters: parameters, completion: completion))
    }
}
