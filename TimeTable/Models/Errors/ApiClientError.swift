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
        
        var localizedDescription: String {
            switch self {
            case .invalidHost(let url):
                return String(format: "api.error.invalid_url".localized, url?.absoluteString ?? "")
            case .invalidParameters:
                return "api.error.invalid_parameters".localized
            case .invalidResponse:
                return "api.error.invalid_response".localized
            case .validationErrors(let validationErrors):
                return validationErrors?.errors.keys.joined(separator: ".\n") ?? ""
            case .serverError(let serverError):
                return  "\(serverError.status) - \(serverError.error)"
            case .noConnection:
                return "api.error.no_connection".localized
            case .timeout:
                return "api.error.timeout".localized
            }
        }
    }
}

// MARK: - Equatable
extension ApiClientError: Equatable {}
extension ApiClientError.ErrorType: Equatable {}
