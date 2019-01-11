//
//  ApiClient.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Networking

typealias ApiClientType = (ApiClientNetworkingType & ApiClientSessionType & ApiClientWorkTimesType & ApiClientProjectsType)

protocol ApiClientNetworkingType: class {
    var networking: NetworkingType { get set }
    
    func post<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void))
    func post<E: Encodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<Void>) -> Void))
    func get<D: Decodable>(_ endpoint: Endpoints, completion: @escaping ((Result<D>) -> Void))
    func get<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void))
}

class ApiClient: ApiClientNetworkingType {
    internal var networking: NetworkingType
    private let encoder: RequestEncoderType
    private let decoder: JSONDecoderType
    
    // MARK: - Initialization
    init(networking: NetworkingType, buildEncoder: (() -> RequestEncoderType), buildDecoder: (() -> JSONDecoderType)) {
        self.networking = networking
        self.networking.headerFields = ["content-type": "application/json"]
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
    
    func post<E: Encodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<Void>) -> Void)) {
        do {
            let parameters = try encoder.encodeToDictionary(wrapper: parameters)
            _ = networking.post(endpoint.rawValue, parameters: parameters) { response in
                switch response {
                case .success:
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(ApiClientError.invalidParameters))
        }
    }
    
    func get<D: Decodable>(_ endpoint: Endpoints, completion: @escaping ((Result<D>) -> Void)) {
        networking.get(endpoint.rawValue, parameters: nil, cachingLevel: .none) { [weak self] response in
            self?.handle(response: response, completion: completion)
        }
    }
    
    func get<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Result<D>) -> Void)) {
        do {
            let parameters = try encoder.encodeToDictionary(wrapper: parameters)
            networking.get(endpoint.rawValue, parameters: parameters, cachingLevel: .none) { [weak self] response in
                self?.handle(response: response, completion: completion)
            }
        } catch {
            completion(.failure(ApiClientError.invalidParameters))
        }
    }
}
