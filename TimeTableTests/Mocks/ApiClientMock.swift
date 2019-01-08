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
    
    private(set) var fetchAllProjectsCompletion: ((Result<[ProjectRecordDecoder]>) -> Void)?
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder]>) -> Void)) {
        fetchAllProjectsCompletion = completion
    }
}
