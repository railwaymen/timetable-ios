//
//  MockServer.swift
//  TimeTableUITests
//
//  Created by Bartłomiej Świerad on 24/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Swifter

class MockServer {
    private let server = HttpServer()
    private(set) var port: UInt16
    
    var baseURL: URL {
        URL(string: "http://localhost:\(self.port)/api")!
    }
    
    var isRunning: Bool {
        self.server.operating
    }
    
    init() {
        self.port = PortGenerator.shared.generateNewPort()
        try? self.start()
    }
    
    deinit {
        self.stop()
    }
    
    // MARK: - Internal
    func setUpDefaultResponses() throws {
        self.setResponse(.ok(.data(Data())), method: .head, endpoint: .head)
        try self.setOkResponse(.signInResponse, forMethod: .post, endpoint: .signIn)
    }
    
    func setOkResponse(_ response: MockResponse, forMethod method: Method, endpoint: Endpoint) throws {
        let data = try GetJSONResource(from: response)
        self.setResponse(.ok(.data(data)), method: method, endpoint: endpoint)
    }
    
    func setResponse(_ response: HttpResponse, method: Method, endpoint: Endpoint) {
        method.set(
            response: response,
            endpoint: "/api" + endpoint.rawValue,
            server: self.server)
    }
    
    func start() throws {
        do {
            try self.server.start(self.port)
        } catch let error as SocketError {
            guard case .bindFailed = error else { throw error }
            self.port = PortGenerator.shared.generateNewPort()
            try self.start()
        }
    }
    
    func stop() {
        self.server.stop()
    }
}

// MARK: - Structures
extension MockServer {
    enum Method {
        case delete
        case head
        case get
        case post
        case put
        
        func set(response: HttpResponse, endpoint: String, server: HttpServer) {
            let responseHandler: (HttpRequest) -> HttpResponse = { _ in response }
            switch self {
            case .get:
                server.get[endpoint] = responseHandler
            case .head:
                server.head[endpoint] = responseHandler
            case .post:
                server.post[endpoint] = responseHandler
            case .put:
                server.put[endpoint] = responseHandler
            case .delete:
                server.delete[endpoint] = responseHandler
            }
        }
    }
    
    enum Endpoint: String {
        case head = ""
        case signIn = "/users/sign_in"
    }
    
    private class PortGenerator {
        static let shared = PortGenerator()
        
        private(set) var occupiedPorts: Int = 0
                
        // MARK: - Internal
        func generateNewPort() -> UInt16 {
            let port: UInt16 = 1 + UInt16(self.occupiedPorts)
            self.occupiedPorts += 1
            return port
        }
    }
}
