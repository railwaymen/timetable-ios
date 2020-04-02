//
//  APIClientFactory.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 22/01/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

protocol APIClientFactoryType: class {
    func buildAPIClient(accessService: AccessServiceApiClientType, baseURL: URL) -> ApiClientType
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
    func buildAPIClient(accessService: AccessServiceApiClientType, baseURL: URL) -> ApiClientType {
        return ApiClient(
            restler: Restler(
                baseURL: baseURL,
                encoder: self.encoder,
                decoder: self.decoder),
            accessService: accessService)
    }
}
