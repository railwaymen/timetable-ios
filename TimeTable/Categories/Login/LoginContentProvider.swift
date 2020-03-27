//
//  LoginContentProvider.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 05/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol LoginContentProviderType: class {
    func login(
        with credentials: LoginCredentials,
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
    func login(
        with credentials: LoginCredentials,
        completion: @escaping ((Result<SessionDecoder, Error>) -> Void)
    ) {
        self.apiClient.signIn(with: credentials) { [unowned self] result in
            switch result {
            case let .success(userDecoder):
                do {
                    try self.accessService.saveSession(userDecoder)
                    completion(.success(userDecoder))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
