//
//  ApiClientMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ApiClientMock: ApiClientSessionType, ApiClientWorkTimesType, ApiClientProjectsType, ApiClientUsersType, ApiClientMatchingFullTimeType {
    
    var fetchSimpleListOfProjectsExpectation: (() -> Void)?
    
    private(set) var signInCredentials: LoginCredentials?
    private(set) var signInCompletion: ((Result<SessionDecoder>) -> Void)?
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        signInCredentials = credentials
        signInCompletion = completion
    }
    
    private(set) var fetchWorkTimesParameters: WorkTimesParameters?
    private(set) var fetchWorkTimesCompletion: ((Result<[WorkTimeDecoder]>) -> Void)?
    var fetchWorkTimesExpectation: (() -> Void)?
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder]>) -> Void)) {
        fetchWorkTimesExpectation?()
        fetchWorkTimesParameters = parameters
        fetchWorkTimesCompletion = completion
    }
    
    private(set) var addWorkTimeParameters: Task?
    private(set) var addWorkTimeComletion: (((Result<Void>) -> Void))?
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        addWorkTimeParameters = parameters
        addWorkTimeComletion = completion
    }
    
    private(set) var deleteWorkTimeIdentifier: Int64?
    private(set) var deleteWorkTimeCompletion: ((Result<Void>) -> Void)?
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void>) -> Void)) {
        deleteWorkTimeIdentifier = identifier
        deleteWorkTimeCompletion = completion
    }

    private(set) var fetchAllProjectsCompletion: ((Result<[ProjectRecordDecoder]>) -> Void)?
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder]>) -> Void)) {
        fetchAllProjectsCompletion = completion
    }
    
    private(set) var fetchSimpleListOfProjectsCompletion: ((Result<[ProjectDecoder]>) -> Void)?
    func fetchSimpleListOfProjects(completion: @escaping ((Result<[ProjectDecoder]>) -> Void)) {
        fetchSimpleListOfProjectsCompletion = completion
        fetchSimpleListOfProjectsExpectation?()
    }
    
    private(set) var fetchUserProfileIdentifier: Int64?
    private(set) var fetchUserProfileCompletion: ((Result<UserDecoder>) -> Void)?
    func fetchUserProfile(forIdetifier identifier: Int64, completion: @escaping ((Result<UserDecoder>) -> Void)) {
        fetchUserProfileIdentifier = identifier
        fetchUserProfileCompletion = completion
    }
    
    private(set) var fetchMatchingFullTimeParameters: MatchingFullTimeEncoder?
    private(set) var fetchMatchingFullTimeCompletion: ((Result<MatchingFullTimeDecoder>) -> Void)?
    var fetchMatchingFullTimeExpectation: (() -> Void)?
    func fetchMatchingFullTime(parameters: MatchingFullTimeEncoder, completion: @escaping ((Result<MatchingFullTimeDecoder>) -> Void)) {
        fetchMatchingFullTimeExpectation?()
        fetchMatchingFullTimeParameters = parameters
        fetchMatchingFullTimeCompletion = completion
    }
    
    private(set) var updateWorkTimeValues: (identifier: Int64, parameters: Task)?
    private(set) var updateWorkTimeCompletion: ((Result<Void>) -> Void)?
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        updateWorkTimeValues = (identifier, parameters)
        updateWorkTimeCompletion = completion
    }
}
