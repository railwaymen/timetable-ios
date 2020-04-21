//
//  ApiClient+Users.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 18/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientUsersType: class {
    func fetchUserProfile(forID id: Int64, completion: @escaping ((Result<UserDecoder, Error>) -> Void))
}

extension ApiClient: ApiClientUsersType {
    func fetchUserProfile(forID id: Int64, completion: @escaping ((Result<UserDecoder, Error>) -> Void)) {
        _ = self.restler
            .get(Endpoint.user(id))
            .decode(UserDecoder.self)
            .onCompletion(completion)
            .start()
    }
}
