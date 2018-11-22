//
//  ApiClient.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Networking

typealias ApiClientType = (ApiClientSessionType)

protocol ApiClientNetworkingType: class {
    func post<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void))
}

class ApiClient {
    private var networking: NetworkingType
    private let encoder: RequestEncoderType
    private let decoder: JSONDecoderType
    
    // MARK: - Initialization
    init(networking: NetworkingType, buildEncoder: (() -> RequestEncoderType), buildDecoder: (() -> JSONDecoderType)) {
        self.networking = networking
        self.networking.headerFields?["content-type"] = "application/json"
        self.encoder = buildEncoder()
        self.decoder = buildDecoder()
    }
    
    // MARK: - Private
    private func decode<D: Decodable>(data: Data, completion: @escaping ((Result<D>) -> Void)) {
        do {
            let decodedResponse = try decoder.decode(D.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(ApiClientError.invalidResponse))
        }
    }
    
    private func handle<D: Decodable>(response: Result<Data>, completion: @escaping ((Result<D>) -> Void)) {
        switch response {
        case .success(let data):
            self.decode(data: data, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    // MARK: - ApiClientNetworkingType
    func post<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void)) {
        do {
            let parameters = try encoder.encodeToDictionary(wrapper: parameters)
            _ = networking.post(endpoint.rawValue, parameters: parameters) { [weak self] response in
                self?.handle(response: response, completion: completion)
            }
        } catch {
            completion(.failure(ApiClientError.invalidParameters))
        }
    }
    
    func get<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void)) {
        do {
            let parameters = try encoder.encodeToDictionary(wrapper: parameters)
            networking.get(endpoint.rawValue, parameters: parameters, cachingLevel: .memory) { [weak self] response in
                self?.handle(response: response, completion: completion)
            }
        } catch {
            completion(.failure(ApiClientError.invalidParameters))
        }
    }
}
