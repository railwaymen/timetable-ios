//
//  ApiClientMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ApiClientMock {
    var networking: NetworkingType = NetworkingMock()
    
    private(set) var signInParams: [SignInParams] = []
    struct SignInParams {
        var credentials: LoginCredentials
        var completion: ((Result<SessionDecoder>) -> Void)
    }
    
    private(set) var fetchWorkTimesParams: [FetchWorkTimesParams] = []
    struct FetchWorkTimesParams {
        var parameters: WorkTimesParameters
        var completion: ((Result<[WorkTimeDecoder]>) -> Void)
    }
    
    private(set) var addWorkTimeParams: [AddWorkTimeParams] = []
    struct AddWorkTimeParams {
        var parameters: Task
        var completion: ((Result<Void>) -> Void)
    }
    
    private(set) var deleteWorkTimeParams: [DeleteWorkTimeParams] = []
    struct DeleteWorkTimeParams {
        var identifier: Int64
        var completion: ((Result<Void>) -> Void)
    }
    
    private(set) var updateWorkTimeParams: [UpdateWorkTimeParams] = []
    struct UpdateWorkTimeParams {
        var identifier: Int64
        var parameters: Task
        var completion: ((Result<Void>) -> Void)
    }
    
    private(set) var fetchAllProjectsParams: [FetchAllProjectsParams] = []
    struct FetchAllProjectsParams {
        var completion: ((Result<[ProjectRecordDecoder]>) -> Void)
    }
    
    private(set) var fetchSimpleListOfProjectsParams: [FetchSimpleListOfProjectsParams] = []
    struct FetchSimpleListOfProjectsParams {
        var completion: ((Result<SimpleProjectDecoder>) -> Void)
    }
    
    private(set) var fetchUserProfileParams: [FetchUserProfileParams] = []
    struct FetchUserProfileParams {
        var identifier: Int64
        var completion: ((Result<UserDecoder>) -> Void)
    }
    
    private(set) var fetchMatchingFullTimeParams: [FetchMatchingFullTimeParams] = []
    struct FetchMatchingFullTimeParams {
        var parameters: MatchingFullTimeEncoder
        var completion: ((Result<MatchingFullTimeDecoder>) -> Void)
    }
}

// MARK: - ApiClientNetworkingType
extension ApiClientMock: ApiClientNetworkingType {}

// MARK: - ApiClientSessionType
extension ApiClientMock: ApiClientSessionType {
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        self.signInParams.append(SignInParams(credentials: credentials, completion: completion))
    }
}

// MARK: - ApiClientWorkTimesType
extension ApiClientMock: ApiClientWorkTimesType {
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder]>) -> Void)) {
        self.fetchWorkTimesParams.append(FetchWorkTimesParams(parameters: parameters, completion: completion))
    }
    
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        self.addWorkTimeParams.append(AddWorkTimeParams(parameters: parameters, completion: completion))
    }
    
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void>) -> Void)) {
        self.deleteWorkTimeParams.append(DeleteWorkTimeParams(identifier: identifier, completion: completion))
    }
    
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        self.updateWorkTimeParams.append(UpdateWorkTimeParams(identifier: identifier, parameters: parameters, completion: completion))
    }
}

// MARK: - ApiClientProjectsType
extension ApiClientMock: ApiClientProjectsType {
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder]>) -> Void)) {
        self.fetchAllProjectsParams.append(FetchAllProjectsParams(completion: completion))
    }
    
    func fetchSimpleListOfProjects(completion: @escaping ((Result<SimpleProjectDecoder>) -> Void)) {
        self.fetchSimpleListOfProjectsParams.append(FetchSimpleListOfProjectsParams(completion: completion))
    }
}

// MARK: - ApiClientUsersType
extension ApiClientMock: ApiClientUsersType {
    func fetchUserProfile(forIdetifier identifier: Int64, completion: @escaping ((Result<UserDecoder>) -> Void)) {
        self.fetchUserProfileParams.append(FetchUserProfileParams(identifier: identifier, completion: completion))
    }
}

// MARK: - ApiClientMatchingFullTimeType
extension ApiClientMock: ApiClientMatchingFullTimeType {
    func fetchMatchingFullTime(parameters: MatchingFullTimeEncoder, completion: @escaping ((Result<MatchingFullTimeDecoder>) -> Void)) {
        self.fetchMatchingFullTimeParams.append(FetchMatchingFullTimeParams(parameters: parameters, completion: completion))
    }
}
