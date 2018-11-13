//
//  DataStackType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore

protocol DataStackType {
    // swiftlint:disable type_name
    typealias T = NSManagedObject
    
    func fetchAll<D>(_ from: From<D>, _ fetchClauses: FetchClause...) -> [D]?
    func perform<T>(asynchronousTask: @escaping (_ transaction: AsynchronousDataTransactionType) throws -> T,
                    success: @escaping (T) -> Void, failure: @escaping (CoreStoreError) -> Void)
    
    // swiftlint:enable type_name
}

extension DataStack: DataStackType {
    func perform<T>(asynchronousTask: @escaping (AsynchronousDataTransactionType) throws -> T,
                    success: @escaping (T) -> Void, failure: @escaping (CoreStoreError) -> Void) {
        perform(asynchronous: asynchronousTask, success: success, failure: failure)
    }
}
