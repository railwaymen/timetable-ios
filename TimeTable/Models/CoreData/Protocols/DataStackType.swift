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
    func fetchAll<D>(_ from: From<D>, _ fetchClauses: FetchClause...) -> [D]?
    func perform<T>(asynchronous task: @escaping (_ transaction: AsynchronousDataTransaction) throws -> T,
                    success: @escaping (T) -> Void, failure: @escaping (CoreStoreError) -> Void)
}

extension DataStack: DataStackType {}
