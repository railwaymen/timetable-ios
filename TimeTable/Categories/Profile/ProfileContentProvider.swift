//
//  ProfileContentProvider.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 23/04/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

protocol ProfileContentProviderViewModelInterface: class {
    typealias UpdateUserDataCompletion = (UserDecoder) -> Void
    func getUserData() -> UserDecoder?
    func updateUserData(successCompletion: @escaping UpdateUserDataCompletion)
    func closeSession()
}

class ProfileContentProvider {
    private let apiClient: ApiClientUsersType
    private let accessService: AccessServiceLoginType
    private let errorHandler: ErrorHandlerType
    
    // MARK: - Initialization
    init(
        apiClient: ApiClientUsersType,
        accessService: AccessServiceLoginType,
        errorHandler: ErrorHandlerType
    ) {
        self.apiClient = apiClient
        self.accessService = accessService
        self.errorHandler = errorHandler
    }
}

// MARK: - ProfileContentProviderViewModelInterface
extension ProfileContentProvider: ProfileContentProviderViewModelInterface {
    func getUserData() -> UserDecoder? {
        self.accessService.getUserData()
    }
    
    func updateUserData(successCompletion: @escaping UpdateUserDataCompletion) {
        guard let userID = self.accessService.getLastLoggedInUserID() else { return }
        self.apiClient.fetchUserProfile(forID: userID) { result in
            switch result {
            case let .success(userData):
                self.accessService.setUserData(userData)
                successCompletion(userData)
            case let .failure(error):
                self.errorHandler.throwing(error: error)
            }
        }
    }
    
    func closeSession() {
        self.accessService.closeSession()
    }
}
