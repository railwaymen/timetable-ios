//
//  AsynchronousDataTransactionType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 08/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation
import CoreStore

protocol AsynchronousDataTransactionType: class {
    func deleteAll<D>(_ from: From<D>, _ deleteClauses: DeleteClause...) -> Int?
    func delete<D: DynamicObject>(_ object: D?)
    func create<D>(_ into: Into<D>) -> D
}

extension AsynchronousDataTransaction: AsynchronousDataTransactionType {}
