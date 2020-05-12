//
//  LoginContentProvider.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol LoginContentProviderType: class {
    func closeSession()
    func login(
        with credentials: LoginCredentials,
        shouldSaveUser: Bool,
        completion: @escaping ((Result<SessionDecoder, Error>) -> Void))
}

class LoginContentProvider {
    private let apiClient: ApiClientSessionType
    private let accessService: AccessServiceLoginType
    
    // MARK: - Initialization
    init(
        apiClient: ApiClientSessionType,
        accessService: AccessServiceLoginType
    ) {
        self.apiClient = apiClient
        self.accessService = accessService
    }
}
    
// MARK: - LoginContentProviderType
extension LoginContentProvider: LoginContentProviderType {
    func closeSession() {
        self.accessService.closeSession()
    }
    
    func login(
        with credentials: LoginCredentials,
        shouldSaveUser: Bool,
        completion: @escaping ((Result<SessionDecoder, Error>) -> Void)
    ) {
        self.apiClient.signIn(with: credentials) { [unowned self] result in
            switch result {
            case let .success(session):
                shouldSaveUser
                    ? self.accessService.openSession(session)
                    : self.accessService.openTemporarySession(session)
                let userData = UserDecoder(
                    id: session.id,
                    firstName: session.firstName,
                    lastName: session.lastName,
                    email: credentials.email)
                self.accessService.setUserData(userData)
                completion(.success(session))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
