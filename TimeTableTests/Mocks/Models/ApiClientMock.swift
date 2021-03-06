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
        let id: Int64
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
        let id: Int64
        let completion: ((Result<Void, Error>) -> Void)
    }
    
    private(set) var updateWorkTimeParams: [UpdateWorkTimeParams] = []
    struct UpdateWorkTimeParams {
        let id: Int64
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
        let id: Int64
        let completion: ((Result<UserDecoder, Error>) -> Void)
    }
    
    // MARK: - ApiClientAccountingPeriodsType
    private(set) var fetchAccountingPeriodsParams: [FetchAccountingPeriodsParams] = []
    struct FetchAccountingPeriodsParams {
        let parameters: AccountingPeriodsParameters
        let completion: (Result<AccountingPeriodsResponse, Error>) -> Void
    }
    
    private(set) var fetchMatchingFullTimeParams: [FetchMatchingFullTimeParams] = []
    struct FetchMatchingFullTimeParams {
        let parameters: MatchingFullTimeEncoder
        let completion: ((Result<MatchingFullTimeDecoder, Error>) -> Void)
    }
    
    // MARK: - ApiClientVacationType
    var fetchVacationReturnValue: RestlerTaskType?
    private(set) var fetchVacationParams: [FetchVacationParams] = []
    struct FetchVacationParams {
        let parameters: VacationParameters
        let completion: FetchVacationCompletion
    }
    
    var addVacationReturnValue: RestlerTaskType?
    private(set) var addVacationParams: [AddVacationParams] = []
    struct AddVacationParams {
        let vacation: VacationEncoder
        let completion: AddVacationCompletion
    }
    
    var declineVacationReturnValue: RestlerTaskType?
    private(set) var declineVacationParams: [DeclineVacationParams] = []
    struct DeclineVacationParams {
        let vacation: VacationDecoder
        let completion: VoidCompletion
    }
    
    // MARK: - ApiClientRemoteWorkType
    var fetchRemoteWorkReturnValue: RestlerTaskType?
    private(set) var fetchRemoteWorkParams: [FetchRemoteWorkParams] = []
    struct FetchRemoteWorkParams {
        let parameters: RemoteWorkParameters
        let completion: FetchRemoteWorkCompletion
    }
    
    var registerRemoteWorkReturnValue: RestlerTaskType?
    private(set) var registerRemoteWorkParams: [RegisterRemoteWorkParams] = []
    struct RegisterRemoteWorkParams {
        let parameters: RemoteWorkRequest
        let completion: RegisterRemoteWorkCompletion
    }
    
    var deleteRemoteWorkReturnValue: RestlerTaskType?
    private(set) var deleteRemoteWorkParams: [DeleteRemoteWorkParams] = []
    struct DeleteRemoteWorkParams {
        let remoteWork: RemoteWork
        let completion: VoidCompletion
    }
    
    var updateRemoteWorkReturnValue: RestlerTaskType?
    private(set) var updateRemoteWorkParams: [UpdateRemoteWorkParams] = []
    struct UpdateRemoteWorkParams {
        let remoteWork: RemoteWork
        let parameters: RemoteWorkRequest
        let completion: UpdateRemoteWorkCompletion
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
        id: Int64,
        completion: @escaping (Result<WorkTimeDecoder, Error>) -> Void
    ) -> RestlerTaskType? {
        self.fetchWorkTimeDetailsParams.append(FetchWorkTimeDetailsParams(id: id, completion: completion))
        return self.fetchWorkTimeDetailsReturnValue
    }
    
    func addWorkTime(parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.addWorkTimeParams.append(AddWorkTimeParams(parameters: parameters, completion: completion))
    }
    
    func addWorkTimeWithFilling(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        self.addWorkTimeWithFillingParams.append(AddWorkTimeWithFillingParams(task: task, completion: completion))
    }
    
    func deleteWorkTime(id: Int64, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.deleteWorkTimeParams.append(DeleteWorkTimeParams(id: id, completion: completion))
    }
    
    func updateWorkTime(id: Int64, parameters: Task, completion: @escaping ((Result<Void, Error>) -> Void)) {
        self.updateWorkTimeParams.append(UpdateWorkTimeParams(
            id: id,
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
    func fetchUserProfile(forID id: Int64, completion: @escaping ((Result<UserDecoder, Error>) -> Void)) {
        self.fetchUserProfileParams.append(FetchUserProfileParams(id: id, completion: completion))
    }
}

// MARK: - ApiClientAccountingPeriodsType
extension ApiClientMock: ApiClientAccountingPeriodsType {
    func fetchAccountingPeriods(
        parameters: AccountingPeriodsParameters,
        completion: @escaping (Result<AccountingPeriodsResponse, Error>) -> Void
    ) {
        self.fetchAccountingPeriodsParams.append(FetchAccountingPeriodsParams(parameters: parameters, completion: completion))
    }
    
    func fetchMatchingFullTime(
        parameters: MatchingFullTimeEncoder,
        completion: @escaping ((Result<MatchingFullTimeDecoder, Error>) -> Void)
    ) {
        self.fetchMatchingFullTimeParams.append(FetchMatchingFullTimeParams(parameters: parameters, completion: completion))
    }
}

// MARK: - ApiClientVacationType
extension ApiClientMock: ApiClientVacationType {
    func fetchVacation(parameters: VacationParameters, completion: @escaping FetchVacationCompletion) -> RestlerTaskType? {
        self.fetchVacationParams.append(FetchVacationParams(parameters: parameters, completion: completion))
        return self.fetchVacationReturnValue
    }

    func addVacation(_ vacation: VacationEncoder, completion: @escaping AddVacationCompletion) -> RestlerTaskType? {
        self.addVacationParams.append(AddVacationParams(vacation: vacation, completion: completion))
        return self.addVacationReturnValue
    }
    
    func declineVacation(_ vacation: VacationDecoder, completion: @escaping VoidCompletion) -> RestlerTaskType? {
        self.declineVacationParams.append(DeclineVacationParams(vacation: vacation, completion: completion))
        return self.declineVacationReturnValue
    }
}

// MARK: - ApiClientRemoteWorkType
extension ApiClientMock: ApiClientRemoteWorkType {
    func fetchRemoteWork(
        parameters: RemoteWorkParameters,
        completion: @escaping FetchRemoteWorkCompletion
    ) -> RestlerTaskType? {
        self.fetchRemoteWorkParams.append(FetchRemoteWorkParams(parameters: parameters, completion: completion))
        return self.fetchRemoteWorkReturnValue
    }
    
    func registerRemoteWork(
        parameters: RemoteWorkRequest,
        completion: @escaping RegisterRemoteWorkCompletion
    ) -> RestlerTaskType? {
        self.registerRemoteWorkParams.append(RegisterRemoteWorkParams(parameters: parameters, completion: completion))
        return self.registerRemoteWorkReturnValue
    }
    
    func deleteRemoteWork(_ remoteWork: RemoteWork, completion: @escaping VoidCompletion) -> RestlerTaskType? {
        self.deleteRemoteWorkParams.append(DeleteRemoteWorkParams(remoteWork: remoteWork, completion: completion))
        return self.deleteRemoteWorkReturnValue
    }
    
    func updateRemoteWork(
        _ remoteWork: RemoteWork,
        with parameters: RemoteWorkRequest,
        completion: @escaping UpdateRemoteWorkCompletion
    ) -> RestlerTaskType? {
        self.updateRemoteWorkParams.append(UpdateRemoteWorkParams(
            remoteWork: remoteWork,
            parameters: parameters,
            completion: completion))
        return self.updateRemoteWorkReturnValue
    }
}
