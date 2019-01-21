//
//  ApiClient+Users.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientUsersType: class {
    func fetchUserProfile(forIdetifier identifier: Int64, completion: @escaping ((Result<UserDecoder>) -> Void))
}

// MARK: - ApiClientUsersType
extension ApiClient: ApiClientUsersType {
    func fetchUserProfile(forIdetifier identifier: Int64, completion: @escaping ((Result<UserDecoder>) -> Void)) {
        get(Endpoints.user(identifier), completion: completion)
    }
}
