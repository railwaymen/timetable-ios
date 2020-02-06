//
//  ApiClient.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Networking

typealias ApiClientType =
    ApiClientNetworkingType
    & ApiClientSessionType
    & ApiClientWorkTimesType
    & ApiClientProjectsType
    & ApiClientUsersType
    & ApiClientMatchingFullTimeType
typealias ApiClientProfileType =
    ApiClientUsersType
    & ApiClientNetworkingType

protocol ApiClientNetworkingType: class {
    func setAuthenticationToken(_ token: String)
    func removeAuthenticationToken()
}

class ApiClient {
    private var networking: NetworkingType
    private let encoder: RequestEncoderType
    private let decoder: JSONDecoderType
    
    // MARK: - Initialization
    init(
        networking: NetworkingType,
        encoder: RequestEncoderType,
        decoder: JSONDecoderType
    ) {
        self.networking = networking
        self.encoder = encoder
        self.decoder = decoder
        
        self.networking.headerFields = ["content-type": "application/json"]
        HTTPCookieStorage.shared.cookieAcceptPolicy = .never
    }
    
    // MARK: - Internal
    func post<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Swift.Result<D, Error>) -> Void)) {
        do {
            let parameters = try self.encoder.encodeToDictionary(wrapper: parameters)
            _ = self.networking.post(endpoint.value, parameters: parameters) { [weak self] response in
                self?.handle(response: response, completion: completion)
            }
        } catch {
            completion(.failure(ApiClientError(type: .invalidParameters)))
        }
    }
    
    func post<E: Encodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Swift.Result<Void, Error>) -> Void)) {
        do {
            let parameters = try self.encoder.encodeToDictionary(wrapper: parameters)
            _ = self.networking.post(endpoint.value, parameters: parameters) { response in
                switch response {
                case .success:
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(ApiClientError(type: .invalidParameters)))
        }
    }
    
    func get<D: Decodable>(_ endpoint: Endpoints, completion: @escaping ((Swift.Result<D, Error>) -> Void)) {
        self.networking.get(endpoint.value, parameters: nil, cachingLevel: .none) { [weak self] response in
            self?.handle(response: response, completion: completion)
        }
    }
    
    func get<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Swift.Result<D, Error>) -> Void)) {
        do {
            let parameters = try self.encoder.encodeToDictionary(wrapper: parameters)
            self.networking.get(endpoint.value, parameters: parameters, cachingLevel: .none) { [weak self] response in
                self?.handle(response: response, completion: completion)
            }
        } catch {
            completion(.failure(ApiClientError(type: .invalidParameters)))
        }
    }
    
    func delete(_ endpoint: Endpoints, completion: @escaping ((Swift.Result<Void, Error>) -> Void)) {
        self.networking.delete(endpoint.value, completion: completion)
    }
    
    func put<E: Encodable, D: Decodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Swift.Result<D, Error>) -> Void)) {
        do {
            let parameters = try self.encoder.encodeToDictionary(wrapper: parameters)
            _ = self.networking.put(endpoint.value, parameters: parameters) { [weak self] response in
                self?.handle(response: response, completion: completion)
            }
        } catch {
            completion(.failure(ApiClientError(type: .invalidParameters)))
        }
    }
    
    func put<E: Encodable>(_ endpoint: Endpoints, parameters: E?, completion: @escaping ((Swift.Result<Void, Error>) -> Void)) {
        do {
            let parameters = try self.encoder.encodeToDictionary(wrapper: parameters)
            _ = self.networking.put(endpoint.value, parameters: parameters) { response in
                switch response {
                case .success:
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(ApiClientError(type: .invalidParameters)))
        }
    }
}

// MARK: - ApiClientNetworkingType
extension ApiClient: ApiClientNetworkingType {
    func setAuthenticationToken(_ token: String) {
        self.networking.headerFields?["token"] = token
    }
    
    func removeAuthenticationToken() {
        self.networking.headerFields?.removeValue(forKey: "token")
    }
}

// MARK: - Private
extension ApiClient {
    private func decode<D: Decodable>(data: Data, completion: @escaping ((Swift.Result<D, Error>) -> Void)) {
        do {
            let decodedResponse = try self.decoder.decode(D.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(ApiClientError(type: .invalidResponse)))
        }
    }
    
    private func handle<D: Decodable>(response: Swift.Result<Data, Error>, completion: @escaping ((Swift.Result<D, Error>) -> Void)) {
        switch response {
        case .success(let data):
            self.decode(data: data, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
