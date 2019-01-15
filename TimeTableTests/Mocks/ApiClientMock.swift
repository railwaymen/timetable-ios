//
//  ApiClientMock.swift
//  TimeTableTests
//
//  Created by Piotr Pawluś on 08/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation
@testable import TimeTable

class ApiClientMock: ApiClientSessionType, ApiClientWorkTimesType, ApiClientProjectsType {
    private(set) var signInCredentials: LoginCredentials?
    private(set) var signInCompletion: ((Result<SessionDecoder>) -> Void)?
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder>) -> Void)) {
        signInCredentials = credentials
        signInCompletion = completion
    }
    
    private(set) var fetchWorkTimesParameters: WorkTimesParameters?
    private(set) var fetchWorkTimesCompletion: ((Result<[WorkTimeDecoder]>) -> Void)?
    func fetchWorkTimes(parameters: WorkTimesParameters, completion: @escaping ((Result<[WorkTimeDecoder]>) -> Void)) {
        fetchWorkTimesParameters = parameters
        fetchWorkTimesCompletion = completion
    }
    
    private(set) var addWorkTimeParameters: Task?
    private(set) var addWorkTimeComletion: (((Result<Void>) -> Void))?
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void>) -> Void)) {
        addWorkTimeParameters = parameters
        addWorkTimeComletion = completion
    }

    private(set) var fetchAllProjectsCompletion: ((Result<[ProjectRecordDecoder]>) -> Void)?
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder]>) -> Void)) {
        fetchAllProjectsCompletion = completion
    }
    
    private(set) var fetchSimpleListOfProjectsCompletion: ((Result<[ProjectDecoder]>) -> Void)?
    func fetchSimpleListOfProjects(completion: @escaping ((Result<[ProjectDecoder]>) -> Void)) {
        fetchSimpleListOfProjectsCompletion = completion
    }
}
