//
//  UserProfileViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol UserProfileViewModelOutput: class {
    func setUp()
    func update(firstName: String, lastName: String, email: String)
}

protocol UserProfileViewModelType: class {
    func viewDidLoad()
    func viewRequestedForLogout()
}

class UserProfileViewModel: UserProfileViewModelType {
    private weak var userInterface: UserProfileViewModelOutput?
    private let coordinator: UserCoordinatorDelegate
    private let apiClient: ApiClientUsersType
    private let accessService: AccessServiceUserIDType
    private let coreDataStack: CoreDataStackUserType
    private let errorHandler: ErrorHandlerType
    
    // MARK: - Initialization
    init(userInterface: UserProfileViewModelOutput?, coordinator: UserCoordinatorDelegate, apiClient: ApiClientUsersType,
         accessService: AccessServiceUserIDType, coreDataStack: CoreDataStackUserType, errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.accessService = accessService
        self.coreDataStack = coreDataStack
        self.errorHandler = errorHandler
    }
    
    // MARK: - UserProfileViewModelType
    func viewDidLoad() {
        userInterface?.setUp()
        guard let userIdentifier = accessService.getLastLoggedInUserIdentifier() else { return }
        apiClient.fetchUserProfile(forIdetifier: userIdentifier) { [weak self] result in
            switch result {
            case .success(let decoder):
                self?.userInterface?.update(firstName: decoder.firstName, lastName: decoder.lastName, email: decoder.email)
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
    
    func viewRequestedForLogout() {
        guard let userIdentifier = accessService.getLastLoggedInUserIdentifier() else { return }
        coreDataStack.deleteUser(forIdentifier: userIdentifier) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.coordinator.userProfileDidLogoutUser()
                }
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}
