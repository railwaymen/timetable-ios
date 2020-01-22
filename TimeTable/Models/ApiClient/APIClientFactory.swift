//
//  APIClientFactory.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 22/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Networking

protocol APIClientFactoryType: class {
    func buildAPIClient(baseURL: URL) -> ApiClientType
}

class APIClientFactory {
    private let encoder: JSONEncoderType
    private let decoder: JSONDecoderType
    private let jsonSerialization: JSONSerializationType
    
    // MARK: - Initialization
    init(
        encoder: JSONEncoderType,
        decoder: JSONDecoderType,
        jsonSerialization: JSONSerializationType
    ) {
        self.encoder = encoder
        self.decoder = decoder
        self.jsonSerialization = jsonSerialization
    }
}

// MARK: - APIClientFactoryType
extension APIClientFactory: APIClientFactoryType {
    func buildAPIClient(baseURL: URL) -> ApiClientType {
        let networking = Networking(baseURL: baseURL.absoluteString)
        return ApiClient(
            networking: networking,
            encoder: RequestEncoder(encoder: self.encoder, serialization: self.jsonSerialization),
            decoder: self.decoder)
    }
}
