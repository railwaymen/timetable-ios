//
//  ApiClientError.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 06/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import Networking

struct ApiClientError: Error {
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter(type: .dateAndTimeExtended))
        return decoder
    }()
    
    let type: ErrorType
    
    // MARK: - Initialization
    init(type: ErrorType) {
        self.type = type
    }
    
    init?(code: Int) {
        switch code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            self.type = .noConnection
        case NSURLErrorTimedOut:
            self.type = .timeout
        case NSURLErrorCannotParseResponse, NSURLErrorBadServerResponse:
            self.type = .invalidResponse
        default:
            return nil
        }
    }
    
    init?(data: Data) {
        if let validationErrors = try? ApiClientError.decoder.decode(ApiValidationErrors.self, from: data) {
            self.type = .validationErrors(validationErrors)
        } else if let serverError = try? ApiClientError.decoder.decode(ServerError.self, from: data) {
            self.type = .serverError(serverError)
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
        case validationErrors(ApiValidationErrors)
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
                return validationErrors.errors.keys.joined(separator: "./n")
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
extension ApiClientError: Equatable {
    static func == (lhs: ApiClientError, rhs: ApiClientError) -> Bool {
        return lhs.type == rhs.type
    }
}

extension ApiClientError.ErrorType: Equatable {
    static func == (lhs: ApiClientError.ErrorType, rhs: ApiClientError.ErrorType) -> Bool {
        switch (lhs, rhs) {
        case (.invalidHost(let lhsURL), .invalidHost(let rhsURL)): return lhsURL == rhsURL
        case (.invalidParameters, .invalidParameters): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.validationErrors(let lhsError), .validationErrors(let rhsError)): return lhsError == rhsError
        case (.serverError(let lhsError), .serverError(let rhsError)): return lhsError == rhsError
        case (.noConnection, .noConnection): return true
        case (.timeout, .timeout): return true
        default: return false
        }
    }
}
