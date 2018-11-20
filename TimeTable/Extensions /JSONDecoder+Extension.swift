//
//  JSONDecoder+Extension.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 07/11/2018.
//  Copyright © 2018 Railwaymen. All rights reserved.
//

import Foundation

protocol JSONDecoderType: class {
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get set }
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}
extension JSONDecoder: JSONDecoderType {}
