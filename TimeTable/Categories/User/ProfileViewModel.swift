//
//  ProfileViewModel.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 17/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ProfileViewModelOutput: class {
    func setUp()
    func update(firstName: String, lastName: String, email: String)
}

protocol ProfileViewModelType: class {
    func viewDidLoad()
    func viewRequestedForLogout()
}

class ProfileViewModel: ProfileViewModelType {
    private weak var userInterface: ProfileViewModelOutput?
    private weak var coordinator: ProfileCoordinatorDelegate?
    private let apiClient: ApiClientUsersType
    private let accessService: AccessServiceUserIDType
    private let coreDataStack: CoreDataStackUserType
    private let errorHandler: ErrorHandlerType
    
    // MARK: - Initialization
    init(userInterface: ProfileViewModelOutput?,
         coordinator: ProfileCoordinatorDelegate,
         apiClient: ApiClientUsersType,
         accessService: AccessServiceUserIDType,
         coreDataStack: CoreDataStackUserType,
         errorHandler: ErrorHandlerType) {
        self.userInterface = userInterface
        self.coordinator = coordinator
        self.apiClient = apiClient
        self.accessService = accessService
        self.coreDataStack = coreDataStack
        self.errorHandler = errorHandler
    }
    
    // MARK: - ProfileViewModelType
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
                self?.coordinator?.userProfileDidLogoutUser()
            case .failure(let error):
                self?.errorHandler.throwing(error: error)
            }
        }
    }
}
