//
//  ApiClientMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ApiClientMock: ApiClientType {
    
    // MARK: - ApiClientNetworkingType
    var networking: NetworkingType = NetworkingMock()
    
    private(set) var postCalled: Bool = false
    private(set) var postEndpoint: Endpoints?
    private(set) var postParameters: Any?
    func post<E, D>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void)) where E: Encodable, D: Decodable {
        postCalled = true
        postEndpoint = endpoint
        postParameters = parameters
    }
    
    func post<E>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<Void>) -> Void)) where E: Encodable {
        postCalled = true
        postEndpoint = endpoint
        postParameters = parameters
    }
    
    private(set) var getCalled: Bool = false
    private(set) var getEndpoint: Endpoints?
    private(set) var getParameters: Any?
    func get<D>(_ endpoint: Endpoints, completion: @escaping ((Result<D>) -> Void)) where D: Decodable {
        getCalled = true
        getEndpoint = endpoint
    }
    
    func get<E, D>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void)) where E: Encodable, D: Decodable {
        getCalled = true
        getEndpoint = endpoint
        getParameters = parameters
    }
    
    private(set) var putCalled: Bool = false
    private(set) var putEndpoint: Endpoints?
    private(set) var putParameters: Any?
    func put<E, D>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void)) where E: Encodable, D: Decodable {
        putCalled = true
        putEndpoint = endpoint
        putParameters = parameters
    }
    
    func put<E>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<Void>) -> Void)) where E: Encodable {
        putCalled = true
        putEndpoint = endpoint
        putParameters = parameters
    }
        
    // MARK: - ApiClientSessionType
    private(set) var signInCredentials: LoginCredentials?
    private(set) var signInCompletion: ((Result<SessionDecoder>) -> Void)?
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        signInCredentials = credentials
        signInCompletion = completion
    }
    
    // MARK: - ApiClientWorkTimesType
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
    
    private(set) var deleteWorkTimeCalled: Bool = false
    private(set) var deleteWorkTimeIdentifier: Int64?
    private(set) var deleteWorkTimeCompletion: ((Result<Void>) -> Void)?
    func deleteWorkTime(identifier: Int64, completion: @escaping ((Result<Void>) -> Void)) {
        deleteWorkTimeCalled = true
        deleteWorkTimeIdentifier = identifier
        deleteWorkTimeCompletion = completion
    }
    
    private(set) var updateWorkTimeValues: (identifier: Int64, parameters: Task)?
    private(set) var updateWorkTimeCompletion: ((Result<Void>) -> Void)?
    func updateWorkTime(identifier: Int64, parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        updateWorkTimeValues = (identifier, parameters)
        updateWorkTimeCompletion = completion
    }

    // MARK: - ApiClientProjectsType
    private(set) var fetchAllProjectsCompletion: ((Result<[ProjectRecordDecoder]>) -> Void)?
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder]>) -> Void)) {
        fetchAllProjectsCompletion = completion
    }
    
    private(set) var fetchSimpleListOfProjectsCompletion: ((Result<SimpleProjectDecoder>) -> Void)?
    var fetchSimpleListOfProjectsExpectation: (() -> Void)?
    func fetchSimpleListOfProjects(completion: @escaping ((Result<SimpleProjectDecoder>) -> Void)) {
        fetchSimpleListOfProjectsCompletion = completion
        fetchSimpleListOfProjectsExpectation?()
    }
    
    // MARK: - ApiClientUsersType
    private(set) var fetchUserProfileIdentifier: Int64?
    private(set) var fetchUserProfileCompletion: ((Result<UserDecoder>) -> Void)?
    func fetchUserProfile(forIdetifier identifier: Int64, completion: @escaping ((Result<UserDecoder>) -> Void)) {
        fetchUserProfileIdentifier = identifier
        fetchUserProfileCompletion = completion
    }
    
    // MARK: - ApiClientMatchingFullTimeType
    private(set) var fetchMatchingFullTimeParameters: MatchingFullTimeEncoder?
    private(set) var fetchMatchingFullTimeCompletion: ((Result<MatchingFullTimeDecoder>) -> Void)?
    var fetchMatchingFullTimeExpectation: (() -> Void)?
    func fetchMatchingFullTime(parameters: MatchingFullTimeEncoder, completion: @escaping ((Result<MatchingFullTimeDecoder>) -> Void)) {
        fetchMatchingFullTimeExpectation?()
        fetchMatchingFullTimeParameters = parameters
        fetchMatchingFullTimeCompletion = completion
    }
}
