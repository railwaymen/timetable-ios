//
//  ApiClientError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Restler

struct ApiClientError: Error, RestlerErrorDecodable {
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.dateAndTimeExtended)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    let type: ErrorType
    
    // MARK: - Initialization
    init(type: ErrorType) {
        self.type = type
    }
    
    init?(response: Restler.Response) {
        if let data = response.data,
            let validationErrors = try? ApiClientError.decoder.decode(ApiValidationErrors.self, from: data) {
            self.type = .validationErrors(validationErrors)
        } else if let data = response.data,
            let serverError = try? ApiClientError.decoder.decode(ServerError.self, from: data) {
            self.type = .serverError(serverError)
        } else if let code = response.response?.statusCode ?? (response.error as NSError?)?.code {
            switch code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
                self.type = .noConnection
            case NSURLErrorTimedOut:
                self.type = .timeout
            case NSURLErrorCannotParseResponse, NSURLErrorBadServerResponse:
                self.type = .invalidResponse
            case 401:
                self.type = .unauthorized
            case 422:
                self.type = .validationErrors(nil)
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}

// MARK: - Structures
extension ApiClientError {
    enum ErrorType {
        case invalidHost(URL?)
        case invalidParameters
        case invalidResponse
        case validationErrors(ApiValidationErrors?)
        case serverError(ServerError)
        case noConnection
        case timeout
        case unauthorized
        
        var localizedDescription: String {
            switch self {
            case .invalidHost(let url):
                return R.string.localizable.apiErrorInvalid_url(url?.absoluteString ?? "")
            case .invalidParameters:
                return R.string.localizable.apiErrorInvalid_parameters()
            case .invalidResponse:
                return R.string.localizable.apiErrorInvalid_response()
            case .validationErrors(let validationErrors):
                let text = validationErrors?.errors.keys.compactMap(\.localizedDescription).first ?? ""
                return text.isEmpty ? UIError.genericError.localizedDescription : text
            case .serverError(let serverError):
                return  "\(serverError.status) - \(serverError.error)"
            case .noConnection:
                return R.string.localizable.apiErrorNo_connection()
            case .timeout:
                return R.string.localizable.apiErrorTimeout()
            case .unauthorized :
                return R.string.localizable.apiErrorUnauthorized()
            }
        }
    }
}

// MARK: - Equatable
extension ApiClientError: Equatable {}
extension ApiClientError.ErrorType: Equatable {}
