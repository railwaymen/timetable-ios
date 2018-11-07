//
//  CustomJSONSerialization.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol JSONSerializationType: class {
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any
}

class CustomJSONSerialization: JSONSerializationType {
    func jsonObject(with data: Data, options: JSONSerialization.ReadingOptions) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: options)
    }
}
