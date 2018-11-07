//
//  JSONEncoderType.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol JSONEncoderType: class {
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get set }
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: JSONEncoderType {}
