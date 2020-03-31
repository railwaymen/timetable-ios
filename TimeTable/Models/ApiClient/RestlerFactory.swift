//
//  RestlerFactory.swift
//  TimeTable
//
//  Created by Bartłomiej Świerad on 31/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

protocol RestlerFactoryType: class {
    func buildRestler(withBaseURL baseURL: URL) -> RestlerType
}

class RestlerFactory: RestlerFactoryType {
    func buildRestler(withBaseURL baseURL: URL) -> RestlerType {
        return Restler(baseURL: baseURL)
    }
}
