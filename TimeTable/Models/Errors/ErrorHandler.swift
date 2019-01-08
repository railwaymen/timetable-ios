//
//  ErrorHandler.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 25/10/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//
/*
 Top-down error architecture:
 https://medium.com/@londeix/top-down-error-architecture-d8715a28d1ad
 */

import Foundation

public class ErrorHandler: ErrorHandlerType {
    
    private var parent: ErrorHandler?
    private let action: HandleAction<Error>
    
    // MARK: - Initialization
    convenience init(action: @escaping HandleAction<Error> = { throw $0 }) {
        self.init(action: action, parent: nil)
    }
    
    private init(action: @escaping HandleAction<Error>, parent: ErrorHandler? = nil) {
        self.action = action
        self.parent = parent
    }
    
    // MARK: - Public
    public func throwing(error: Error, finally: @escaping (Bool) -> Void) {
        throwing(error: error, previous: [], finally: finally)
    }
    
    public func catchingError(action: @escaping HandleAction<Error>) -> ErrorHandlerType {
        return ErrorHandler(action: action, parent: self)
    }
    
    // MARK: - Private
    private func throwing(error: Error, previous: [ErrorHandler], finally: ((Bool) -> Void)? = nil) {
        if let parent = parent {
            parent.throwing(error: error, previous: previous + [self], finally: finally)
            return
        }
        serve(error: error, next: AnyCollection(previous.reversed()), finally: finally)
    }
    
    private func serve(error: Error, next: AnyCollection<ErrorHandler>, finally: ((Bool) -> Void)? = nil) {
        do {
            try action(error)
            finally?(true)
        } catch {
            if let nextHandler = next.first {
                nextHandler.serve(error: error, next: next.dropFirst(), finally: finally)
            } else {
                finally?(false)
            }
        }
    }
}
