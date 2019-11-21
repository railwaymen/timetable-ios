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
    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: ObjectRepresentation
    func delete<O: ObjectRepresentation>(_ object: O?, _ objects: O?...)
    func create<O>(_ into: Into<O>) -> O
}

extension AsynchronousDataTransaction: AsynchronousDataTransactionType {}
