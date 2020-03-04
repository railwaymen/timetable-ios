//
//  ApiClient+Session.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 22/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientSessionType: class {
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder, Error>) -> Void))
}

extension ApiClient: ApiClientSessionType {
    func signIn(with credentials: LoginCredentials, completion: @escaping ((Result<SessionDecoder, Error>) -> Void)) {
        _ = self.restler
            .post(Endpoint.signIn)
            .body(credentials)
            .failureDecode(ApiClientError.self)
            .decode(SessionDecoder.self)
            .onCompletion(completion)
            .start()
    }
}
